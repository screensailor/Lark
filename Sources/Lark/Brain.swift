final public class Brain<Lemma, Signal> where
    Lemma: Hashable,
    Signal: Castable, // TODO: Codable istead of Castable
    Signal: ExpressibleByNilLiteral,
    Signal: ExpressibleByErrorValue
{
    // TODO: thread-safety
    public typealias Lexicon     = BufferedKeyPathSubjects<[Lemma: Concept]>
    public typealias Functions   = [Lemma: Func.Type]
    public typealias Network     = [Lemma: Neuron]
    public typealias State       = BufferedKeyPathSubjects<DefaultingDictionary<Lemma, Signal>>
    
    public let functions: Functions
    public var lexicon:   Lexicon // TODO: eventually compiled from more ergonomic languages
    
    var network: Network = [:]
    let state =  State([Lemma: Signal]().defaulting(to: nil)) // TODO: Signal.init(Peek.Error("Uninitialized"))

    public init(functions: Functions = [:], lexicon: Lexicon = .init([:])) {
        self.functions = functions
        self.lexicon = lexicon
    }
}

extension Brain {

    public struct Concept: Hashable {
        
        public let connections: [Lemma]
        public let action: Lemma
        
        public init(_ connections: [Lemma] = [], _ action: Lemma) {
            self.connections = connections
            self.action = action
        }
        
        @inlinable public init(connections: [Lemma] = [], action: Lemma) {
            self.init(connections, action)
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
}

extension Brain.Concept: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "\(Self.self)(connections: \(connections), action: \(action))"
    }
}

