@_exported import Combine

import Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

enum OS {
    typealias Lemma = String
}

class Brain<Lemma, Signal> where Lemma: Hashable {
    
    typealias Lexicon     = [Lemma: Concept]
    typealias Connections = [Lemma: Connection]
    typealias Functions   = [Lemma: Function]
    typealias Network     = [Lemma: Node]
    typealias State       = [Lemma: Signal]
    
    var lexicon:     Lexicon = [:]
    var connections: Connections = [:]
    var functions:   Functions = [:]
    var network:     Network = [:]
    var state:       State = [:]

    init(_ lexicon: Lexicon) {
        self.lexicon = lexicon
    }
    
    subscript(lemma: Lemma) -> Node {
        network[lemma] ?? { o in
            network[lemma] = o
            return o
        }(Node())
    }
}

extension Brain {
    
    struct Concept {
        let connections: [Lemma: Connection.Name]
        let action: Brain.Function.Name
    }

    struct Connection {
        typealias Name = OS.Lemma
        let ƒ: (Signal) throws -> Signal
    }
    
    enum Function {
        typealias Name = OS.Lemma
        case ƒ0(() throws -> Signal)
        case ƒ1((Signal) throws -> Signal)
        case ƒ2((Signal, Signal) throws -> Signal)
        case ƒ3((Signal, Signal, Signal) throws -> Signal)
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
