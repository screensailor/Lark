import Lark
import Hope

class Buffered™: Hopes {
    
    func test() {
        
        let o = Buffered(0)
        
        hope(o) == Buffered(0, 0)
        
        o.buffer += 1
        
        hope(o.value) == 0
        hope(o.buffer) == 1
        
        hope(o) == Buffered(0, 1)
        hope(o.swapped == (1, 0)) == true
        
        o.swap()
        hope((1, 0) == o) == true
        
        o.buffer += 1
        o.buffer += 1
        
        hope(o) == Buffered(1, 2)
        
        o.commit()
        hope(o) == Buffered(2, 2)
    }
    
    func test_Buffered_JSON() {
        
        let json: JSON = ["a": 1, "b": [2, 3]]
        
        let o = Buffered(json)
        
        o["b", 1] = "✅"
        
        hope(o["b", 1]) == 3
        hope(o.value["b", 1]) == 3
        hope(o.buffer["b", 1]) == "✅"
        
        o.buffer.peek("💛")

        hope(o) == Buffered(json, ["a": 1, "b": [2, "✅"]])
    }
}

