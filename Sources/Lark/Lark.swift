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

struct Concept<Lemma, Signal> where Lemma: Hashable {
    let input: [Lemma: InputFunction] = [:]
    let action: OutputFunction.Type
}

class Brain<Lemma, Signal> where Lemma: Hashable {
    
    typealias Lexicon = [Lemma: Concept<Lemma, Signal>]
    typealias Network = [Lemma: Node]
    
    @Published var lexicon: Lexicon = [:]
    
    var network: Network = [:]
    
    subscript(lemma: Lemma) -> Concept<Lemma, Signal>? {
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
                subject: network[lemma]?.subject ?? .init(.empty)
            )
        }
    }
    
    struct Node {
        let concept: Concept<Lemma, Signal>
        let subject: CurrentValueSubject<JSON, Error>
    }
}
