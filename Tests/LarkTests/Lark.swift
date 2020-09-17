@_exported import Peek
@_exported import Hope
@_exported import Lark

@testable import Lark

class Lark™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Functions = [String: Func.Type]
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept
    
    struct Sum: Func {
        
        func ƒ<X>(_ x: [X]) throws -> X where X: Castable {
            let o = try x.reduce(0){ a, e in try a + e.as(Double.self) }
            return try X(o)
        }
    }
    
    struct Product: Func {
        
        func ƒ<X>(_ x: [X]) throws -> X where X: Castable {
            let o = try x.reduce(1){ a, e in try a * e.as(Double.self) }
            return try X(o)
        }
    }

    let functions: Functions = [
        "": Identity.self,
        "+": Sum.self,
        "*": Product.self
    ]
    
    func test() {
        let o = Sink.Var<JSON>(nil)
        let brain = Brain(functions: functions)

        o ...= brain.published("new concept")

        brain.lexicon["new concept"] = Concept(
            connections: ["x", "y"],
            action: "+"
        )

        brain["x"] = 2
        brain["y"] = 3
        
        2.times(brain.commit)

        hope(o[]) == 5
    }
    
    func test_2() {
        let o = Sink.Var<JSON>(nil)
        let brain = Brain(functions: functions)
        
        o ...= brain.published("x * (a + b + c)")
        
        brain.lexicon["x * (a + b + c)"] = Concept(
            connections: ["x", "a + b + c"],
            action: "*"
        )
        
        brain.lexicon["a + b + c"] = Concept(
            connections: ["a", "b", "c"],
            action: "+"
        )
        
        brain["a"] = 1
        brain["b"] = 2
        brain["c"] = 3
        brain["x"] = 10
        
        3.times(brain.commit)
        
        hope(o[]) == 60
    }
}

