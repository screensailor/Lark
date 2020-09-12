import Lark
import Hope

class Scope™: Hopes {
    
    private var bag: Bag = []
    
    @Published private var json: JSON = .empty
    
    func test() {
        
        let o = Sink.Var(0 as JSON)
        
        let path: [JSON.Index] = ["a", "b", 3]
        
        o ...= $json.map(\.[path]) / bag
        
        hope(o.value) == nil
        
        json[path] = "c"
        
        hope(o.value) == "c"
    }
    
    func test_1() {
        
    }
}


