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
    
    func test_2() {
        typealias Lexicon = Lark.Lexicon<String, JSON>
        typealias Concept = Lexicon.Concept
        typealias Brain = Lexicon.Brain
        
        let lexicon = Lexicon()
        let brain = Brain(lexicon)
        
        let o = Sink.Optional<JSON>()
        
        o ...= brain["some concept", default: 0]
        
        brain.lexicon.book["some concept"] = Concept(
            connections: ["x": "", "y": ""],
            action: "+"
        )
        
        brain.lexicon.book["x"] = Concept(connections: [:], action: "")
        brain.lexicon.book["y"] = Concept(connections: [:], action: "")
    }
}
