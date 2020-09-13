@_exported import Peek
@testable import Lark
import Hope

class Lark™: Hopes {
    
    @Published private var json: JSON = .empty
    
    func test() {
        
        let o = Sink.Optional(0 as JSON)
        
        let x: JSON.Path = ["a", "b", 3]
        
        o ...= $json.map(\.[x])
        
        hope(o.value) == nil
        
        json[x] = "c"
        
        hope(o.value) == "c"
    }
    
    func test_1() {
        
        let o = Sink.Result(0)

        let x = $json["a", "b", 3].as(Int.self)
        let y = $json["somewhere", "else"].as(Int.self)
        
        o ...= x.combineLatest(y).map(+) // o = x|Int + y|Int

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
        
        brain.functions[""] = Brain.Function.ƒ1{ $0 }
        brain.functions["+"] = Brain.Function.ƒ2{ try JSON($0.cast(to: Int.self) + $1.cast(to: Int.self)) }
        
        brain["some concept"] = Concept(
            connections: [
                "x": "",
                "y": ""
            ],
            action: "+"
        )
        
        brain["x"] = Concept(connections: [:], action: "")
        brain["y"] = Concept(connections: [:], action: "")

        let o = Sink.Optional<JSON>()
        
        o ...= brain["some concept", default: 0]

        brain["x", default: 0].send(2)
        brain["y", default: 0].send(3)
        
        // hope(o.value) == 5
    }
}
