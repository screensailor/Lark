@_exported import Combine
@_exported import Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

protocol AnyFunc { init() }
protocol Func: AnyFunc { associatedtype X }
protocol Func₀: Func { func ƒ() throws -> X }
protocol Func₁: Func { func ƒ(_ x: X) throws -> X }
protocol Func₂: Func { func ƒ(_ x: (X, X)) throws -> X }

struct OS<Lemma, Signal> where Lemma: Hashable {

    var functions: [Lemma: AnyFunc.Type] = [:] // TODO: use function builder as a namespace
}

class Brain<Lemma, Signal> where Lemma: Hashable {
    
    typealias Lexicon     = [Lemma: Concept]
    typealias Connections = [Lemma: Lemma?]
    typealias Functions   = [Lemma: Lemma]
    typealias Network     = [Lemma: Node]
    typealias State       = BufferedKeyPathSubjects<[Lemma: Signal]>
    
    @Published var lexicon:     Lexicon = [:] // TODO: eventually compiled from more ergonomic languages
    @Published var connections: Connections = [:]
    @Published var functions:   Functions = [:]
    @Published var network:     Network = [:]
    
    let state = State([:]) // TODO: accumulated changes must be explicitly committed (e.g. per run loop)
    
    let os: OS<Lemma, Signal>
    
    init(on os: OS<Lemma, Signal>) { self.os = os }
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
