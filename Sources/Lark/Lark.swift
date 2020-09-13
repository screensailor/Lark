@_exported import Combine

import Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

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
    typealias Node = CurrentValueSubject<Signal, Error>
    
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
    
    private(set) var lexicon: Lexicon
    private(set) var network: Network = [:]
    
    init(_ lexicon: Lexicon) {
        self.lexicon = lexicon
    }
    
    subscript(lemma: Lemma) -> Concept? {
        get { lexicon.book[lemma] }
        set { lexicon.book[lemma] = newValue }
    }
    
    subscript(lemma: Lemma, default o: Signal) -> Node {
        let node = CurrentValueSubject<Signal, Error>(o)
        network[lemma] = node
        return node
    }
}

enum OS {
    typealias Lemma = String
}
