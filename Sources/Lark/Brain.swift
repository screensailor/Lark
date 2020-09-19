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
    
    private lazy var subjects = Subjects([:]){ [weak self] lemma in
        guard let self = self else { return Subject(nil) }
        return Subject(self.state[lemma])
    }

    private lazy var nervs = Subjects([:]){ [weak self] lemma in
        guard let self = self else { return Subject(nil) }
        return Subject(self.state[lemma])
    }
    
    private var neurons: [Lemma: Neuron] = [:]

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

    @discardableResult
    public func commit(thoughts count: Int = 1) -> [Lemma: Signal] {
        var writes = self.change
        state[].merge(writes){ $1 }
        (0 ..< max(count, 0)).forEach{ _ in
            for (lemma, signal) in writes {
                nervs[lemma]?.send(signal)
            }
            writes = self.thoughts
            self.change.merge(writes){ $1 }
            self.thoughts.removeAll(keepingCapacity: true)
            state[].merge(writes){ $1 }
        }
        for (lemma, signal) in self.change {
            subjects[lemma]?.send(signal)
        }
        self.change.removeAll(keepingCapacity: true)
        self.change.merge(writes){ $1 }
        return writes
    }
}

extension Brain {

    public struct Concept: Hashable {
        public let connections: [Lemma]
        public let function: Lemma
    }
}

extension Brain.Concept {
    
    public init(_ connections: [Lemma] = [], _ function: Lemma) {
        self.connections = connections
        self.function = function
    }
}

extension Brain {
    
    public class Neuron {
        
        public let lemma: Lemma
        public let concept: Concept
        public let ƒ: BrainFunction
        
        @Published var input: [Signal] = []
        
        private var bag: Set<AnyCancellable> = []
        
        init(_ lemma: Lemma, in mind: Brain) throws {
            
            guard let concept = mind.lexicon[lemma] else {
                throw "Missing concept for lemma '\(lemma)'".error()
            }
            guard let function = mind.functions[concept.function] else {
                throw "Function '\(concept.function)' not found for concept '\(lemma)'".error()
            }
            
            self.lemma = lemma
            self.concept = concept
            self.ƒ = function
            
            input = Array(repeating: nil, count: concept.connections.count) // TODO: Signal.void
            
            $input.flatMap{ [weak self] x -> AnyPublisher<Signal, Never> in
                self?.ƒ(x: x).eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
            }.sink{ [weak mind] x in
                mind?.thoughts[lemma] = x
            }.store(in: &bag)
            
            for (i, connection) in concept.connections.enumerated() {
                mind.nervs[connection].sink{ [weak self] signal in
                    self?.input[i] = signal
                }.store(in: &self.bag)
            }
        }
    }
}
