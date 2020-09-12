import Lark
import Hope

class AnyTree™: Hopes {
    
    private var bag: Bag = []
    
    func test_return_self() {
        let o = 4 as JSON
        hope(o[]) == 4
    }
    
    func test_set_self() {
        var o = 4 as JSON
        o[] = 5
        hope(o[]) == 5
    }
    
    func test_subscript_default() {
        let o: JSON = .empty
        hope(o["a", default: 1]) == 1
    }
}
