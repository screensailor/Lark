@_exported import Combine
@_exported import Foundation

// Hope

infix operator ± : RangeFormationPrecedence

// Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

// TODO: handwritten recurrent neural networks
private protocol Name {}           // Key in Tree<Key, Leaf>
private protocol Signal {}         // Leaf in Tree<Key, Leaf> 
private protocol Concept {}        // node
private protocol Lexicon {}        // network
private protocol InputFunction {}  // input transform (weight)
private protocol OutputFunction {} // action potential


