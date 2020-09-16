@_exported import Peek
@_exported import Hope
@_exported import Lark

@testable import Lark

class Lark™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept
    
    let os = OS<String, JSON>(
        functions: [
            "": .ƒ₁{ $0 },
            "+": .ƒ₂{ try JSON(Double($0) + Double($1)) }
        ]
    )
    func test_1() {
        let o = Sink.Optional<JSON>(nil)
        let brain = Brain(on: os)
        
        o ...= brain.state.published["?"]
        
        brain.state["?"] = "🙂"
        
        hope(o[]) == nil
        
        brain.state.commit()
        
        hope(o[]) == "🙂"
    }
    
//    func test_3() {
//        let o = Sink.Var<JSON>(nil)
//        let brain = Brain(on: os)
//
//        brain["?"].send("Yay!")
//
//        o ...= brain["?"]
//
//        hope(o[]) == "Yay!"
//    }
//
//    func test_4() {
//        let o = Sink.Var<JSON>(nil)
//        let brain = Brain(on: os)
//
//        let lemma = "a new conept"
//
//        o ...= brain[lemma]
//
//        brain.lexicon[lemma] = Concept(
//            connections: [
//                "x": nil,
//                "y": nil
//            ],
//            action: "+"
//        )
//
//        brain.lexicon["x"] = Concept(action: "")
//        brain.lexicon["y"] = Concept(action: "")
//
//        brain["x"].send(2) // e.g. user event
//        brain["y"].send(3) // e.g. database push
//
//        //hope(o[]) == 5
//    }
}

