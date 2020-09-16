@_exported import Peek
@_exported import Hope
@_exported import Lark

@testable import Lark

class Lark™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Functions = [String: Func.Type]
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept
    
    struct Identity: Func₁ {

        func ƒ(_ x: JSON) throws -> JSON { x }
    }
    
    struct Add: Func₂ {

        func ƒ(_ x: (JSON, JSON)) throws -> JSON {
            try JSON(Double(x.0) + Double(x.1))
        }
    }
    
    let functions: Functions = [
        "": Identity.self,
        "+": Add.self
    ]

    func test_1() {
        let o = Sink.Var<JSON?>(nil)
        let brain = Brain()
        
        o ...= brain.state.published["?"]
        
        brain.state["?"] = "🙂"
        
        hope(o[]) == nil
        
        brain.state.commit()
        
        hope(o[]) == "🙂"
    }
    
    func test_2() {
        let o = Sink.Var<JSON?>(nil)
        let brain = Brain()

        brain.state["?"] = "🙂"

        brain.state.commit()

        o ...= brain.state.published["?"]
        
        hope(o[]) == "🙂"
    }

    func test_3() {
        let o = Sink.Var<JSON?>(nil)
        let brain = Brain(functions)

        o ...= brain.state.published["new conept"]

        brain.lexicon["new conept"] = Concept(
            connections: [
                "x": "",
                "y": ""
            ],
            action: "+"
        )

        brain.state["x"] = 2
        brain.state["y"] = 3
        
        brain.state.commit()

//        hope(o[]) == 5
    }
}

