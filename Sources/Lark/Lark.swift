@_exported import Combine
@_exported import Foundation

// Hope

infix operator ± : RangeFormationPrecedence

// Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

private protocol Lemma {}          // ontology
private protocol Signal {}         // i/o value
private protocol Concept {}        // node
private protocol Lexicon {}        // network
private protocol InputFunction {}  // input transform (weight)
private protocol OutputFunction {} // action potential transform

private func example() {
    
    class Lexicon<Lemma, Signal> where Lemma: Hashable {}
    
    struct Concept<Lemma, Signal> where Lemma: Hashable {
        let input: [Lemma: InputFunction]
        let action: OutputFunction
    }
}
