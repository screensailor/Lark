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
    
    typealias Lexicon = Lark.Lexicon<String, JSON>
    typealias Concept = Lexicon.Concept
    typealias Brain = Lexicon.Brain
    
    let lexicon = Lexicon()
    
    func test_2() {
        let brain = Brain(lexicon)
        
        let x = Sink.Var<JSON>(.empty)
        
        x ...= brain["?"]
        
        brain["?"].send("Yay!")
        
        hope(x.value) == "Yay!"
    }
    
    func test_3() {
        let brain = Brain(lexicon)
        
        brain["?"].send("Yay!")
        
        let x = Sink.Var<JSON>(.empty)
        
        x ...= brain["?"]
        
        hope(x.value) == "Yay!"
    }

    func test_4() {
        let brain = Brain(lexicon)
        
        brain.functions[""] = Brain.Function.ƒ1{ $0 }
        brain.functions["+"] = Brain.Function.ƒ2{ try JSON($0.cast(to: Int.self) + $1.cast(to: Int.self)) }
        
        brain.lexicon.book["some concept"] = Concept(
            connections: [
                "x": "",
                "y": ""
            ],
            action: "+"
        )
        
        brain.lexicon.book["x"] = Concept(connections: [:], action: "")
        brain.lexicon.book["y"] = Concept(connections: [:], action: "")

        let o = Sink.Var<JSON>(.empty)
        
        o ...= brain["some concept"]

        brain["x"].send(2)
        brain["y"].send(3)
        
        hope(o.value) == 5
    }
}
