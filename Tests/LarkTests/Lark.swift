@_exported import Peek
@testable import Lark
import Hope

class Lark™: Hopes {
    
    @Published private var json: JSON = .empty
    
    func test() {
        
        let o = Sink.Optional<JSON>()
        
        let x: JSON.Path = ["a", "b", 3]
        
        o ...= $json[x]
        
        hope(o.value) == nil
        
        json[x] = "c"
        
        hope(o.value) == "c"
    }
    
    func test_1() {
        
        let o = Sink.Result(0)

        let x = $json["a", "b", 3].as(Int.self)
        let y = $json["somewhere", "else"].as(Int.self)
        
        o ...= x.combineLatest(y).map(+)

        hope(o.value) == 0
        
        json["a", "b", 3] = 4
        
        hope(o.value) == 0

        json["somewhere", "else"] = 12

        hope(o.value) == 16
    }
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept
    
    let lexicon = Lexicon()
    
    func test_2() {
        let o = Sink.Var<JSON>(.empty)
        let brain = Brain(lexicon)
        
        o ...= brain["?"]
        
        brain["?"].send("Yay!")
        
        hope(o.value) == "Yay!"
    }
    
    func test_3() {
        let o = Sink.Var<JSON>(.empty)
        let brain = Brain(lexicon)
        
        brain["?"].send("Yay!")
        
        o ...= brain["?"]
        
        hope(o.value) == "Yay!"
    }

    func test_4() {
        let o = Sink.Var<JSON>(.empty)
        let brain = Brain(lexicon)
        
        o ...= brain["some concept"]
        
        brain.functions[""] = Brain.Function.ƒ1{ $0 }
        brain.functions["+"] = Brain.Function.ƒ2{ try JSON($0.as(Int.self) + $1.as(Int.self)) }
        
        brain.lexicon["some concept"] = Concept(
            connections: [
                "x": "",
                "y": ""
            ],
            action: "+"
        )
        
        brain.lexicon["x"] = Concept(connections: [:], action: "")
        brain.lexicon["y"] = Concept(connections: [:], action: "")

        brain["x"].send(2)
        brain["y"].send(3)
        
        hope(o.value) == 5
    }
}
