import Lark
import Hope

class KeyPathSubject™: Hopes {
    
    private var bag: Bag = []
    
    func test() {
        
        let store: CurrentValueSubject<JSON, Never> = .init(.empty)
        
        let o = Sink.Var(0 as JSON)
        
        o ...= store.map(\.["a", 1]).compacted() / bag
        
        hope(o.value) == 0
        
        store.send(["a": ["b", "c", "d"]])
        
        hope(o.value) == "c"
    }
}



