final public class Brain<Lemma, Signal> where
    Lemma: Hashable,
    Signal: BrainWave
{
    public typealias Lexicon = [Lemma: Concept]
    public typealias Functions = [Lemma: BrainFunction]
    
    public let lexicon: Lexicon
    public let functions: Functions

    public typealias State = DefaultingDictionary<Lemma, Signal>
    public typealias Subject = CurrentValueSubject<Signal, Never>
    public typealias Subjects = DefaultInsertingDictionary<Lemma, Subject>

    public private(set) var state: State
    public private(set) var change: [Lemma: Signal] = [:]
    public private(set) var thoughts = State(default: nil)
    
    private var neurons: [Lemma: Neuron] = [:]
    private var observers: [Lemma: Set<Lemma>] = [:]

    private lazy var subjects = Subjects { [weak self] lemma in
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
        for lemma in lexicon.keys {
            guard let concept = lexicon[lemma] else {
                throw "Missing concept for lemma '\(lemma)'".error()
            }
            guard let ƒ = functions[concept.ƒ] else {
                throw "Function '\(concept.ƒ)' not found for concept '\(lemma)'".error()
            }
            neurons[lemma] = Neuron(lemma, concept, ƒ)
            concept.x.forEach{ x in observers[x, default: []].insert(lemma) }
        }
    }
}

extension Brain {

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { change[lemma] = newValue }
    }
    
    public subscript() -> [Lemma: Signal] {
        get { state[] }
        set { change = newValue }
    }

    public func subject(_ lemma: Lemma) -> Subject { subjects[lemma] }
}

extension Brain {
    
    @discardableResult
    public func commit(thoughts count: Int = 1) -> [Lemma: Signal] {
        var writes = change.merging(thoughts[]){ o, x in o.peek("Replacing thought \(x)", as: .info) }
        state[].merge(writes){ _, o in o }
        (0 ..< max(count, 0)).forEach{ _ in
            for lemma in affected(by: writes) {
                neurons[lemma]?.commit(to: self)
            }
            writes = thoughts[]
            guard !writes.isEmpty else { return }
            thoughts[].removeAll(keepingCapacity: true)
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
    
    func affected(by changes: [Lemma: Signal]) -> Set<Lemma> {
        return changes.keys.reduce(into: Set<Lemma>()){ a, e in a.formUnion(observers[e] ?? []) }
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

        private var y: AnyCancellable?
        
        init(_ lemma: Lemma, _ concept: Concept, _ ƒ: BrainFunction) {
            (self.lemma, self.concept, self.ƒ) = (lemma, concept, ƒ)
        }
        
        func commit(to brain: Brain) {
            let x = concept.x.map{ x in brain.state[x] } // TODO: form permanent references instead
            switch ƒ
            {
            case let ƒ as SyncBrainFunction:
                if let y = Signal.catch({ try ƒ.ƒ(x: x) }) { // TODO: @autoclosure
                    brain.thoughts[lemma] = y
                }
                
            default:
                y = ƒ(x)
                    .receive(on: RunLoop.main) // TODO: on Brain.queue
                    .assign(to: \.thoughts[lemma], on: brain)
            }
        }
    }
}

extension Brain: CustomStringConvertible {
    public var description: String { "\(Self.self)" }
}
