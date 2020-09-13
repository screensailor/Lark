@testable import Lark
import Hope

class Scope™: Hopes {
    
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
        let lexicon = Lexicon<String, JSON>()
        let brain = Brain<String, JSON>(lexicon)
        
        let o = Sink.Optional(0)
        
        o ...= brain["some concept"]
    }
}

extension Brain {
        
    subscript<T>(lemma: Lemma, default t: T) -> CurrentValueSubject<T, Error> {
        .init(t)
    }
    
    subscript<T>(lemma: Lemma, as: T.Type = T.self) -> CurrentValueSubject<T?, Error> {
        .init(nil)
    }
}
