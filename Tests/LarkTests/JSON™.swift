import Lark
import Hope

class JSON™: Hopes {
    
    private var bag: Bag = []
    
    func test_subscript() {        
        var o: JSON = "👋"
        
        hope(o[]) == "👋"
        
        o["a", 2] = 3
        
        hope(o) == ["a": [nil, nil, 3]]
        
        o["a", 1] = 2
        
        hope(o) == ["a": [nil, 2, 3]]

        o[] = ["a": ["b": 2, "c": [3, 4, ["d": "😅"]]]]
        
        hope(o["a", "b"]) == 2
        hope(o["a", "c", 2, "d"]) == "😅"

        o["a", "b"] = 3
        hope(o["a", "b"]) == 3
        
        o["a", "c", 2, "d"] = "✅"
        hope(o["a", "c", 2, "d"]) == "✅"
    }

    func test_any() throws {
        let o: JSON = ["a": ["c": [3, 4, ["d": "😅"]]]]
        let json1 = try JSONSerialization.data(withJSONObject: o.cast(to: [String: Any].self), options: [])
        let json2 = try JSONSerialization.data(withJSONObject: ["a": ["c": [3, 4, ["d": "😅"]]]], options: [])
        hope(json1) == json2
    }
    
//    func test_subscript_default() {
//        let o: JSON = .empty
//        hope(o["a", 2, default: 3]) == 3
//    }
}
