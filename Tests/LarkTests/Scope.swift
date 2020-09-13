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
        
        let o = Sink.Optional(0)
        
        let x: JSON.Path = ["a", "b", 3]
        let y: JSON.Path = ["somewhere", "else"]

        let x$ = $json.compactMap(\.[x]).tryMap{ o -> Int in try o.cast() }
        let y$ = $json.compactMap(\.[y]).tryMap{ o -> Int in try o.cast() }
        
        o ...= x$.combineLatest(y$).map(+) // o = x|Int + y|Int

        hope(o.value) == 0
        
        json[x] = 4
        
        hope(o.value) == 0

        json[y] = 12

        hope(o.value) == 16
    }
    
    func test_2() {
        let _ = Lexicon<String, JSON>()
        let brain = Brain<String, JSON>()
        
        let o = Sink.Optional(0)
        
        o ...= brain["some concept"]
    }
}

extension Brain {
    
    subscript<T>(lemma: Lemma, default t: T, as: T.Type = T.self) -> CurrentValueSubject<T, Error> {
        .init(t)
    }
    
    subscript<T>(lemma: Lemma, as: T.Type = T.self) -> CurrentValueSubject<T?, Error> {
        .init(nil)
    }
}
