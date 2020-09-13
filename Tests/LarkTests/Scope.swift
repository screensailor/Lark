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

        let x$ = $json.compactMap(\.[x]).tryMap{ o -> Int in try o.cast() }
        let y$ = $json.compactMap(\.[y]).tryMap{ o -> Int in try o.cast() }
        
        o ...= x$.combineLatest(y$).map(+)

        hope(o.value) == 0
        
        json[x] = 4
        
        hope(o.value) == 0

        json[y] = 12

        hope(o.value) == 16
    }
    
    func test_2() {
        struct Identity: InputFunction, OutputFunction {}
        
        let lexicon = Lexicon<String, JSON>()
        
        let concept = Concept<String, JSON>(action: Identity.self)
        
        lexicon["concept"] = concept
    }
}

private protocol InputFunction {}
private protocol OutputFunction {}

private struct Concept<Lemma, Signal> where Lemma: Hashable {
    let input: [Lemma: InputFunction] = [:]
    let action: OutputFunction.Type
}

private class Lexicon<Lemma, Signal> where Lemma: Hashable {
    
    @Published private var book: [Lemma: Entry] = [:]
    
    subscript(lemma: Lemma) -> Concept<Lemma, Signal>? {
        get {
            fatalError()
        }
        set {
            
        }
    }
}

private extension Lexicon {
    
    struct Entry {
        let concept: Concept<Lemma, Signal>
    }
}
