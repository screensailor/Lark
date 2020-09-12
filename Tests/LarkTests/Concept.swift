import Lark
import Hope

class Concept™: Hopes {
    
    func test() {
        
    }
}

private protocol Symbol {}

private protocol Concept {
    var symbol: Symbol { get }
}

private struct In<A, B> {
    let symbol: Symbol
    let ƒ: (A) throws -> B
}

private struct Concept0: Concept {
    let symbol: Symbol
}

private struct Concept1<In1, A, B>: Concept {
    let symbol: Symbol
    let input: Symbol
    let map: (In1) -> A
    let ƒ: (A) throws -> B
}

private struct Concept2<In1, In2, A, B, C>: Concept {
    let symbol: Symbol
    let input1: Symbol
    let input2: Symbol
    let map1: (In1) -> A
    let map2: (In2) -> B
    let ƒ: (A, B) throws -> C
}


