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
    typealias Subject = CurrentValueSubject<Signal, Error>
    
    struct Node {
        let concept: Concept
        let subject: Subject?
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
}

enum OS {
    typealias Lemma = String
}
