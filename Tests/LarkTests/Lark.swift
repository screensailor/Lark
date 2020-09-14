@_exported import Peek
@testable import Lark
import Hope

class Lark™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept

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
    
    func test_2() {
        let o = Sink.Var<JSON>(.empty)
        let brain = Brain()
        
        o ...= brain["?"]
        
        brain["?"].send("Yay!")
        
        hope(o.value) == "Yay!"
    }
    
    func test_3() {
        let o = Sink.Var<JSON>(.empty)
        let brain = Brain()
        
        brain["?"].send("Yay!")
        
        o ...= brain["?"]
        
        hope(o.value) == "Yay!"
    }

    func test_4() {
        let o = Sink.Var<JSON>(.empty)
        let brain = Brain()
        
        o ...= brain["some concept"]
        
        brain.functions[""] = Brain.Function.ƒ1{ $0 }
        brain.functions["+"] = Brain.Function.ƒ2{ try JSON(Int($0) + Int($1)) }
        
        brain.lexicon["some concept"] = Concept(
            connections: [
                "x": "",
                "y": ""
            ],
            action: "+"
        )
        
        brain.lexicon["x"] = Concept(action: "")
        brain.lexicon["y"] = Concept(action: "")

        brain["x"].send(2)
        brain["y"].send(3)
        
        hope(o.value) == 5
    }
}

extension Equatable {
    static var o: Self.Type { self }
}


