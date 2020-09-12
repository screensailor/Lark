import Lark
import Hope

class JSON™: Hopes {
    
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
    
    func test_subscript() {
        let o: JSON = ["a": ["b": 2, "c": [3, 4, ["d": "😅"]]]]
        hope(o["a", "b"]) == 2
        hope(o["a", "c", 2, "d"]) == "😅"
    }
}
