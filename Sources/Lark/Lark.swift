import Peek

@_exported import Combine
@_exported import Foundation

// Hope

infix operator ± : RangeFormationPrecedence

// Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

struct Lexicon<Lemma, Signal> where Lemma: Hashable {
    
    typealias Brain = Lark.Brain<Lemma, Signal>

    struct Concept {
        let input: [Lemma: Brain.Function]
        let action: Brain.Function
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
    
    struct Function {
        
    }
}
