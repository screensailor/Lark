@_exported import Combine

import Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

struct OS<Lemma, Signal> where Lemma: Hashable {
    
    var functions: [Lemma: Function] = [:]
    
    enum Function {
        case ƒ₀(() throws -> Signal)
        case ƒ₁((Signal) throws -> Signal)
        case ƒ₂((Signal, Signal) throws -> Signal)
        case ƒ₃((Signal, Signal, Signal) throws -> Signal)
    }
}

class Brain<Lemma, Signal> where Lemma: Hashable {
    
    typealias Lexicon     = [Lemma: Concept]
    typealias Connections = [Lemma: Lemma?]
    typealias Functions   = [Lemma: Lemma]
    typealias Network     = [Lemma: Node]
    typealias State       = [Lemma: Signal]
    
    @Published var lexicon:     Lexicon = [:]
    @Published var connections: Connections = [:]
    @Published var functions:   Functions = [:]
    @Published var network:     Network = [:]
    @Published var state:       State = [:]
    
    let os: OS<Lemma, Signal>
    
    init(on os: OS<Lemma, Signal>) {
        self.os = os
    }
}

extension Brain {
    
    subscript(lemma: Lemma) -> Node {
        network[lemma] ?? { o in
            network[lemma] = o
            return o
        }(Node())
    }
}

extension Brain {
    
    struct Concept {
        
        let connections: Connections
        let action: Lemma?
        
        init(connections: Connections = [:], action: Lemma? = nil) {
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
