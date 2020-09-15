@testable import Lark
import Hope

class Buffered™: Hopes {
    
    func test() {
        
        let o = Buffered(0)
        
        hope(o.__o == (0, 0)) == true // internal
        
        o[] += 1
        o[] += 1
        o[] += 1

        hope(o[]) == 0
        hope(o) != Buffered(0)
        hope(o.committed) == Buffered(1)
        hope(o.__o == (0, 1)) == true // internal

        o.commit()
        hope(o) == Buffered(1)
        hope(o.__o == (1, 1)) == true

        o[] += 1
        o[] += 1
        o[] += 1

        hope(o[]) == 1
        hope(o) != Buffered(1)
        hope(o) != Buffered(2)

        o.commit()
        
        hope(o[]) == 2
        hope(o) == Buffered(2)
        hope(o.__o == (2, 2)) == true // internal
    }
    
    func test_Buffered_JSON() {
        
        let json: JSON = ["a": 1, "b": [2, 3]]
        
        let o = Buffered(json)
        
        o["b", 1] = "✅"
        
        hope(o["b", 1]) == 3
        hope(o[]) == json

        o.commit()
        
        hope(o[]) == ["a": 1, "b": [2, "✅"]]
    }
}

