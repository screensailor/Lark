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

        o ...= brain.published("new conept")

        brain.lexicon["new conept"] = Concept(
            connections: [
                "x": "",
                "y": ""
            ],
            action: "+"
        )

        brain["x"] = 2
        brain["y"] = 3
        
        brain.commit()
        brain.commit()

        hope(brain[]) == [
            "x": 2,
            "y": 3,
//            "new concept": 5
        ]
    }
}

