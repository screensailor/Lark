final public class Brain<Lemma, Signal> where
    Lemma: Hashable,
    Signal: Castable, // TODO: Codable istead of Castable
    Signal: ExpressibleByNilLiteral,
    Signal: ExpressibleByErrorValue
{
    public typealias Lexicon     = BufferedKeyPathSubjects<[Lemma: Concept]>
    public typealias Connections = [Lemma]
    public typealias Functions   = [Lemma: Func.Type]
    public typealias Network     = [Lemma: Neuron]
    public typealias State       = BufferedKeyPathSubjects<DefaultingDictionary<Lemma, Signal>>
    
    let functions: Functions
    var lexicon:   Lexicon // TODO: eventually compiled from more ergonomic languages
    
    private var network: Network = [:]
    private let state =  State([Lemma: Signal]().defaulting(to: nil)) // TODO: accumulated changes must be explicitly committed (e.g. per run loop)

    public init(functions: Functions = [:], lexicon: Lexicon = .init([:])) {
        self.functions = functions
        self.lexicon = lexicon
    }
}

extension Brain {

    public struct Concept: Hashable {
        
        public let connections: Connections
        public let action: Lemma
        
        public init(connections: Connections = [], action: Lemma) {
            self.connections = connections
            self.action = action
        }
    }
}

extension Brain {

    public subscript() -> [Lemma: Signal] {
        get { state[] }
        set { state[] = newValue }
    }

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { state[lemma] = newValue }
    }

    public func commit() {
        lexicon.commit()
        state.commit()
        network.values.forEach{ neuron in neuron.commit() }
    }
}

extension Brain {

    public typealias Potential = CurrentValueSubject<Signal, Never>

    public func published(_ lemma: Lemma) -> Potential {
        if network[lemma] == nil {
            network[lemma] = Neuron(lemma, in: self)
        }
        return state.published[lemma]
    }

    public class Neuron {
        
        public let lemma: Lemma
        
        public private(set) var concept: Concept? { didSet { connectionsBag = [] } }
        public private(set) var signals: [Signal] = []
        
        private var function: Func?
        private var brain: Brain? { didSet { emptyBags() } }
        
        private var conceptBag: Set<AnyCancellable> = []
        private var connectionsBag: Set<AnyCancellable> = []
        
        fileprivate init(_ lemma: Lemma, in brain: Brain) {
            self.lemma = lemma
            self.brain = brain
            brain.lexicon.published[lemma].sink{ [weak self, weak brain] concept in
                guard let self = self, let brain = brain else { return }
                guard let concept = concept else {
                    self.concept = nil // TODO: a more obvious formalism for a binding with OS
                    return
                }
                self.concept = concept
                self.function = brain.functions[concept.action]?.init() // TODO: error if missing
                self.signals = Array(repeating: nil, count: concept.connections.count) // TODO: Signal.init(Peek.Error("Uninitialized"))
                for (i, connection) in concept.connections.enumerated() {
                    if brain.network[connection] == nil {
                        brain.network[connection] = Neuron(connection, in: brain)
                    }
                    brain.state.published[connection].sink{ [weak brain, weak self] signal in
                        guard let brain = brain else {
                            self?.conceptBag = []
                            self?.connectionsBag = []
                            return
                        }
                        guard let self = self else {
                            brain[].removeValue(forKey: lemma)
                            return
                        }
                        self.signals[i] = signal // TODO: equality check?
                    }
                    .store(in: &self.connectionsBag)
                }
            }
            .store(in: &conceptBag)
        }
        
        func commit() {
            guard let brain = brain, let concept = concept else { return }
            do {
                guard let o = function else { // TODO: move to the point of receiving the concept
                    throw "No function '\(concept.action)'".error()
                }
                brain[lemma] = try o.ƒ(self.signals)
            } catch {
                brain[lemma] = Signal.init(Peek.Error("\(error)"))
            }
        }
        
        func emptyBags() {
            conceptBag = []
            connectionsBag = []
        }
        
        deinit {
            emptyBags()
            brain?[].removeValue(forKey: lemma)
        }
    }
}

extension Brain.Concept: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "\(Self.self)(connections: \(connections), action: \(action))"
    }
}

