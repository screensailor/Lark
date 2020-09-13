@_exported import Combine

import Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

enum OS {
    typealias Lemma = String
}

struct Lexicon<Lemma, Signal> where Lemma: Hashable {
    
    typealias Brain = Lark.Brain<Lemma, Signal>

    struct Concept {
        let connections: [Lemma: Brain.Connection.Name]
        let action: Brain.Function.Name
    }
    
    var book: [Lemma: Concept] = [:]
}

class Brain<Lemma, Signal> where Lemma: Hashable {
    
    typealias Lexicon = Lark.Lexicon<Lemma, Signal>
    typealias Concept = Lexicon.Concept
    typealias Network = [Lemma: Node]
    
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
    
    var connections: [OS.Lemma: Brain.Connection] = [:]
    var functions: [OS.Lemma: Brain.Function] = [:]
    
    @Published var lexicon: Lexicon = .init()
    private(set) var network: Network = [:]
    
    init(_ lexicon: Lexicon) {
        self.lexicon = lexicon
    }
    
    subscript(lemma: Lemma) -> Node {
        let node = network[lemma] ?? { o in
            network[lemma] = o
            return o
        }(Node())
        return node
    }
}

extension Brain {
    
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
