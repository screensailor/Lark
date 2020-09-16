@_exported import Peek
@_exported import Hope
@_exported import Lark

@testable import Lark

class Lark™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
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
    
    let os = OS<String, JSON>(
        functions: [
            "": Identity.self,
            "+": Add.self
        ]
    )
    func test_1() {
        let o = Sink.Var<JSON?>(nil)
        let brain = Brain(on: os)
        
        o ...= brain.state.published["?"]
        
        brain.state["?"] = "🙂"
        
        hope(o[]) == nil
        
        brain.state.commit()
        
        hope(o[]) == "🙂"
    }
    
    func test_2() {
        let o = Sink.Var<JSON?>(nil)
        let brain = Brain(on: os)

        brain.state["?"] = "🙂"

        brain.state.commit()

        o ...= brain.state.published["?"]
        
        hope(o[]) == "🙂"
    }

    func test_3() {
        let o = Sink.Var<JSON?>(nil)
        let brain = Brain(on: os)

        let lemma = "a new conept"

        o ...= brain.state.published[lemma]

        brain.lexicon[lemma] = Concept(
            connections: [
                "x": nil,
                "y": nil
            ],
            action: "+"
        )

        brain.lexicon["x"] = Concept(action: "")
        brain.lexicon["y"] = Concept(action: "")

        brain.state["x"] = 2 // e.g. user event
        brain.state["y"] = 3 // e.g. database push
        
        brain.state.commit()

//        hope(o[]) == 5
    }
}

