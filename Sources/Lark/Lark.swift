@_exported import Combine
@_exported import Foundation

// Hope

infix operator ± : RangeFormationPrecedence

// Peek

infix operator ¶ : TernaryPrecedence

// Lark

infix operator ...= : BitwiseShiftPrecedence

// TODO: 
private protocol Concept {}        // neural node
private protocol Lexicon {}        // neural network
private protocol InputFunction {}  // input transform (weight)
private protocol OutputFunction {} // action potential


