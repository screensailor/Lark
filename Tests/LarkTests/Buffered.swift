import Lark
import Hope

class Buffered™: Hopes {
    
    func test() {
        
        let o = Buffered(0)
        
        hope(o) == Buffered(0, 0)
        
        o.value += 1
        o.value += 1
        o.value += 1

        hope(o.value) == 0
        
        hope(o) == Buffered(0, 1)
        hope(o.committed) == Buffered(1, 1)
        
        o.commit()
        hope(o) == Buffered(1, 1)

        o.value += 1
        o.value += 1
        o.value += 1

        hope(o) == Buffered(1, 2)
        
        o.commit()
        hope(o) == Buffered(2, 2)
    }
    
    func test_Buffered_JSON() {
        
        let json: JSON = ["a": 1, "b": [2, 3]]
        
        let o = Buffered(json)
        
        o["b", 1] = "✅"
        
        hope(o["b", 1]) == 3
        hope(o.value) == json

        o.commit()
        
        hope(o.value) == ["a": 1, "b": [2, "✅"]]
    }
}

