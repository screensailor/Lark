@_exported import Combine
@_exported import Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

protocol Func { init() }
protocol Func₀: Func { associatedtype X; func ƒ() throws -> X }
protocol Func₁: Func { associatedtype X; func ƒ(_ x: X) throws -> X }
protocol Func₂: Func { associatedtype X; func ƒ(_ x: (X, X)) throws -> X }

class Brain<Lemma, Signal>
where
    Lemma: Hashable,
    Signal: ExpressibleByNilLiteral
{
    
    typealias Lexicon     = [Lemma: Concept]
    typealias Connections = [Lemma: Lemma]
    typealias Functions   = [Lemma: Func.Type]
    typealias Network     = [Lemma: Node]
    typealias State       = BufferedKeyPathSubjects<DefaultingDictionary<Lemma, Signal>>
    
    var lexicon:        Lexicon = [:] // TODO: eventually compiled from more ergonomic languages
    var connections:    Connections = [:]
    let functions:      Functions // TODO: use function builder as a namespace
    var network:        Network = [:]
    private let state = State([Lemma: Signal]().defaulting(to: nil)) // TODO: accumulated changes must be explicitly committed (e.g. per run loop)

    init(_ functions: Functions = [:]) {
        self.functions = functions
    }
}

extension Brain {

    typealias Potential = CurrentValueSubject<Signal, Never>

    subscript(concept: Lemma) -> Signal {
        get { state[concept] }
        set { state[concept] = newValue }
    }
    
    func potential(_ concept: Lemma) -> Potential {
        state.published[concept]
    }

    func commit() {
        state.commit()
    }
}

extension Brain {

    struct Concept {
        
        let connections: Connections
        let action: Lemma
        
        init(connections: Connections = [:], action: Lemma) {
            self.connections = connections
            self.action = action
        }
    }

    class Node: Subject {
        
        typealias Output = Signal
        typealias Failure = Never
        
        var signal: Signal? {
            didSet {
                guard let signal = signal else { return }
                subject.send(signal)
            }
        }
        
        let subject = PassthroughSubject<Signal, Never>()
        
        func send(_ value: Signal) {
            signal = value
        }
        
        func send(completion: Subscribers.Completion<Never>) {
            subject.send(completion: completion)
        }
        
        func send(subscription: Subscription) {
            subject.send(subscription: subscription)
        }
        
        func receive<S>(subscriber: S)
        where S: Subscriber, Failure == S.Failure, Output == S.Input
        {
            if let signal = signal { _ = subscriber.receive(signal) }
            subject.receive(subscriber: subscriber)
        }
    }
}

private extension Optional where Wrapped: ExpressibleByNilLiteral {
    var orNil: Wrapped { self ?? nil }
}
