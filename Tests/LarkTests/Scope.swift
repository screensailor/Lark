import Lark
import Hope

class Scope™: Hopes {
    
    private var bag: Bag = []
    
    @Published private var json: JSON = .empty
    
    func test() {
        
        let o = Sink.Var(0 as JSON)
        
        o ...= $json.map(\.["a", 1]).compacted().removeDuplicates() / bag
        
        hope(o.value) == 0
        
        json["a", 1] = "c"
        
        hope(o.value) == "c"
    }
}



