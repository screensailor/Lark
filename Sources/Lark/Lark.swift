import Peek

@_exported import Combine
@_exported import Foundation

// Hope

infix operator ± : RangeFormationPrecedence

// Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

protocol InputFunction {}
protocol OutputFunction {}

struct Lexicon<Lemma, Signal> where Lemma: Hashable {

    struct Concept {
        let input: [Lemma: InputFunction.Type] = [:]
        let action: OutputFunction.Type
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

    var lexicon: Lexicon = .init()
    
    var network: Network = [:]
    
    subscript(lemma: Lemma) -> Lexicon.Concept? {
        get {
            network[lemma]?.concept
        }
        set {
            guard let concept = newValue else {
                network.removeValue(forKey: lemma)
                return
            }
            // TODO: do nothing if the concept did not change
            network[lemma] = Node(
                concept: concept,
                subject: nil
            )
        }
    }
}
