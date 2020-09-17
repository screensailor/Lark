@_exported import Combine
@_exported import Peek

infix operator ¶ : TernaryPrecedence

// Lark

protocol Func {
    init()
    func ƒ<X>(_ x: [X]) throws -> X where X: Castable
}

struct Identity: Func {

    func ƒ<X>(_ x: [X]) throws -> X where X : Castable {
        guard x.count == 1 else { throw "\(Identity.self) x.count: \(x.count)".error() }
        return x[0]
    }
}

class Brain<Lemma, Signal>
where
    Lemma: Hashable,
    Signal: Castable,
    Signal: ExpressibleByNilLiteral
{
    
    typealias Lexicon     = CurrentKeyPathSubjects<[Lemma: Concept]>
    typealias Connections = [Lemma]
    typealias Functions   = [Lemma: Func.Type]
    typealias Network     = [Lemma: Neuron]
    typealias State       = BufferedKeyPathSubjects<DefaultingDictionary<Lemma, Signal>>
    
    var lexicon =       Lexicon([:]) // TODO: eventually compiled from more ergonomic languages
    var connections:    Connections = []
    let functions:      Functions // TODO: use function builder as a namespace
    var network:        Network = [:]
    private let state = State([Lemma: Signal]().defaulting(to: nil)) // TODO: accumulated changes must be explicitly committed (e.g. per run loop)

    init(_ functions: Functions = [:]) {
        self.functions = functions
    }
}

extension Brain {

    struct Concept: Hashable {
        
        let connections: Connections
        let action: Lemma
        
        init(connections: Connections = [], action: Lemma) {
            self.connections = connections
            self.action = action
        }
    }
}

extension Brain {

    typealias Potential = CurrentValueSubject<Signal, Never>

    subscript() -> [Lemma: Signal] {
        get { state[] }
        set { state[] = newValue }
    }

    subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { state[lemma] = newValue }
    }

    func commit() {
        state.commit()
    }
}

extension Brain {

    func published(_ lemma: Lemma) -> Potential {
        if network[lemma] == nil {
            network[lemma] = Neuron(lemma, in: self)
        }
        return state.published[lemma]
    }

    class Neuron {
        
        typealias Output = Signal
        typealias Failure = Never
        
        let lemma: Lemma
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
                            brain[lemma] = nil // TODO: Lemma.error(_:)
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
    
    var debugDescription: String {
        "\(Self.self)(connections: \(connections), action: \(action))"
    }
}


