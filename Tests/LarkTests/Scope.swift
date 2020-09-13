import Lark
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

        let x$ = $json.map(\.[x]).tryCompactMap{ try $0?.cast(to: Int.self) }
        let y$ = $json.map(\.[y]).tryCompactMap{ try $0?.cast(to: Int.self) }
        
        o ...= x$.combineLatest(y$).map(+)

        hope(o.value) == 0
        
        json[x] = 4
        
        hope(o.value) == 0

        json[y] = 12

        hope(o.value) == 16
    }
}

let t = Publishers.CombineLatest<
    CurrentValueSubject<Int, Never>,
    CurrentValueSubject<String, Never>
>.self

private protocol InputFunction {}
private protocol OutputFunction {}

private class Lexicon<Lemma, Signal> where Lemma: Hashable {}

private struct Concept<Lemma, Signal> where Lemma: Hashable {
    let input: [Lemma: InputFunction]
    let action: OutputFunction
}
