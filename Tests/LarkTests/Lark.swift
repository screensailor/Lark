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
    
    let functions: Functions = [
        "": Identity.self,
        "+": Sum.self
    ]

    func test_1() {
        let o = Sink.Var<JSON>(nil)
        let brain = Brain()
        
        o ...= brain.published(":)")
        
        brain[":)"] = "🙂"
        
        hope(o[]) == nil
        
        brain.commit()
        
        hope(o[]) == "🙂"
    }
    
    func test_2() {
        let o = Sink.Var<JSON>(nil)
        let brain = Brain()

        brain[":)"] = "😞"
        brain.commit()

        o ...= brain.published(":)")
        
        hope(o[]) == "😞"
        
        brain[":)"] = "🙂"
        brain.commit()
        
        hope(o[]) == "🙂"
    }
    
    func test_3() {
        let o = Sink.Var<Brain.Concept?>(nil)
        let brain = Brain(functions)
        
        o ...= brain.lexicon.published["new concept"]
        
        hope(o[]) == nil
        
        let concept = Concept(action: "Hello world!")

        brain.lexicon["new concept"] = concept

        hope(o[]) == concept
    }

    func test_4() {
        let o = Sink.Var<JSON>(nil)
        let brain = Brain(functions)
        
        hope(brain[]) == [:]

        o ...= brain.published("new concept")

        brain.lexicon["new concept"] = Concept(
            connections: ["x", "y"],
            action: "+"
        )
        
        brain.commit()

        brain["x"] = 2
        brain["y"] = 3
        
        2.times(brain.commit)

        hope(o[]) == 5
    }
}

