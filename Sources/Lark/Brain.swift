final public class Brain<Lemma, Signal> where
    Lemma: Hashable,
    Signal: Castable, // TODO: Codable istead of Castable
    Signal: ExpressibleByNilLiteral,
    Signal: ExpressibleByErrorValue
{
    public typealias Lexicon     = CurrentKeyPathSubjects<[Lemma: Concept]>
    public typealias Connections = [Lemma]
    public typealias Functions   = [Lemma: Func.Type]
    public typealias Network     = [Lemma: Neuron]
    public typealias State       = BufferedKeyPathSubjects<DefaultingDictionary<Lemma, Signal>>
    
    var lexicon =        Lexicon([:]) // TODO: eventually compiled from more ergonomic languages
    let functions:       Functions
    
    private var network: Network = [:]
    private let state =  State([Lemma: Signal]().defaulting(to: nil)) // TODO: accumulated changes must be explicitly committed (e.g. per run loop)

    public init(_ functions: Functions = [:]) {
        self.functions = functions
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

    public typealias Potential = CurrentValueSubject<Signal, Never>

    public subscript() -> [Lemma: Signal] {
        get { state[] }
        set { state[] = newValue }
    }

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { state[lemma] = newValue }
    }

    public func commit() {
        state.commit()
    }
}

extension Brain {

    public func published(_ lemma: Lemma) -> Potential {
        if network[lemma] == nil {
            network[lemma] = Neuron(lemma, in: self)
        }
        return state.published[lemma]
    }

    public class Neuron {
        
        typealias Output = Signal
        typealias Failure = Never
        
        public let lemma: Lemma
        var concept: Concept? { didSet { connectionsBag = [] } }
        
        var signals: [Signal] = []
        
        var conceptBag: Set<AnyCancellable> = []
        var connectionsBag: Set<AnyCancellable> = []
        
        init(_ lemma: Lemma, in brain: Brain) {
            self.lemma = lemma
            brain.lexicon.published[lemma].sink{ [weak brain, weak self] concept in
                guard let brain = brain else {
                    self?.conceptBag = []
                    self?.connectionsBag = []
                    return
                }
                guard let self = self else {
                    brain[].removeValue(forKey: lemma)
                    return
                }
                guard let concept = concept else {
                    self.concept = nil
                    brain[].removeValue(forKey: lemma)
                    return
                }
                self.concept = concept
                self.signals = Array(repeating: nil, count: concept.connections.count)
                for (i, connection) in concept.connections.enumerated() {
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
                        do {
                            guard let o = brain.functions[concept.action]?.init() else {
                                throw "No function '\(concept.action)'".error()
                            }
                            brain[lemma] = try o.ƒ(self.signals)
                        } catch {
                            brain[lemma] = Signal.init(Peek.Error("\(error)"))
                        }
                    }
                    .store(in: &self.connectionsBag)
                }
            }
            .store(in: &conceptBag)
        }
    }
}

extension Brain.Concept: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "\(Self.self)(connections: \(connections), action: \(action))"
    }
}

