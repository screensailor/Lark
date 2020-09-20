final public class Brain<Lemma, Signal> where
    Lemma: Hashable,
    Signal: BrainWave
{
    public typealias Lexicon = [Lemma: Concept]
    public typealias Functions = [Lemma: BrainFunction]
    
    public let lexicon: [Lemma: Concept]
    public let functions: [Lemma: BrainFunction]

    public typealias State = DefaultingDictionary<Lemma, Signal>
    public typealias Subject = CurrentValueSubject<Signal, Never>
    public typealias Subjects = DefaultInsertingDictionary<Lemma, Subject>

    private var state = [Lemma: Signal]().defaulting(to: nil)
    private var change: [Lemma: Signal] = [:]
    private var thoughts: [Lemma: Signal] = [:]
    private var neurons: [Lemma: Neuron] = [:]

    private lazy var subjects = Subjects([:]){ [weak self] lemma in
        guard let self = self else { return Subject(nil) }
        return Subject(self.state[lemma])
    }

    private lazy var nervs = Subjects([:]){ [weak self] lemma in
        guard let self = self else { return Subject(nil) }
        return Subject(self.state[lemma])
    }

    public init(
        _ lexicon: Lexicon = [:],
        _ functions: Functions = [:],
        _ state: [Lemma: Signal] = [:]
    ) throws {
        self.state = state.defaulting(to: nil)
        self.lexicon = lexicon
        self.functions = functions
        for (lemma, _) in lexicon {
            neurons[lemma] = try Neuron(lemma, in: self)
        }
    }
}

extension Brain {
    
    public subscript(lemma: Lemma) -> Subject {
        subjects[lemma]
    }

    public subscript() -> [Lemma: Signal] {
        get { state[] }
        set { change = newValue }
    }

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { change[lemma] = newValue }
    }
    
    @inlinable public func subject(_ lemma: Lemma) -> Subject { self[lemma] }
    @inlinable public func state(of lemma: Lemma) -> Signal { self[lemma] }

    @discardableResult
    public func commit(thoughts count: Int = 1) -> [Lemma: Signal] {
        var writes = change.merging(thoughts){ o, x in o.peek(as: .error, "Replacing thought \(x)") }
        state[].merge(writes){ _, o in o }
        (0 ..< max(count, 0)).forEach{ _ in
            for (lemma, signal) in writes {
                nervs[lemma]?.send(signal)
            }
            writes = thoughts
            guard !writes.isEmpty else { return }
            thoughts.removeAll(keepingCapacity: true)
            change.merge(writes){ _, o in o }
            state[].merge(writes){ _, o in o }
        }
        for (lemma, signal) in change {
            subjects[lemma]?.send(signal)
        }
        change.removeAll(keepingCapacity: true)
        change.merge(writes){ _, o in o }
        return change
    }
}

extension Brain {

    public struct Concept: Hashable {
        public let ƒ: Lemma
        public let x: [Lemma]
    }
}

extension Brain.Concept {
    public init(_ ƒ: Lemma, _ x: Lemma...) { self.init(ƒ, x) }
    public init(_ ƒ: Lemma, _ x: [Lemma]) { self.init(ƒ: ƒ, x: x) }
}

extension Brain {
    
    public class Neuron {
        
        public let lemma: Lemma
        public let concept: Concept
        public let ƒ: BrainFunction
        
        @Published var x: [Signal] = []
        
        private var bag: Set<AnyCancellable> = []
        
        init(_ lemma: Lemma, in brain: Brain) throws {
            
            guard let concept = brain.lexicon[lemma] else {
                throw "Missing concept for lemma '\(lemma)'".error()
            }
            guard let ƒ = brain.functions[concept.ƒ] else {
                throw "Function '\(concept.ƒ)' not found for concept '\(lemma)'".error()
            }
            
            self.lemma = lemma
            self.concept = concept
            self.ƒ = ƒ
            
            x = Array(repeating: nil, count: concept.x.count) // TODO: Signal.void
            
            $x.flatMap{ [weak self] x -> AnyPublisher<Signal, Never> in
                self?.ƒ(x: x).eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
            }.sink{ [weak brain] x in // TODO: move to the brain's queue
                brain?.thoughts[lemma] = x
            }.store(in: &bag)
            
            for (i, connection) in concept.x.enumerated() {
                brain.nervs[connection].sink{ [weak self] signal in
                    self?.x[i] = signal
                }.store(in: &self.bag)
            }
        }
    }
}
