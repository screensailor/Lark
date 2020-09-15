@testable import Lark
import Hope

class Buffered™: Hopes {
    
    func test() {
        
        let o = Buffered(0)
        
        hope.true(o.__o == (0, 0)) // internal
        
        o[] += 1
        o[] += 1
        o[\.self] += 1

        hope(o[]) == 0
        hope(o) != Buffered(0)
        hope(o.committed) == Buffered(1)
        hope.true(o.__o == (0, 1)) // internal

        o.commit()
        hope(o) == Buffered(1)
        hope.true(o.__o == (1, 1))

        o[] += 1
        o[] += 1
        o[] += 1

        hope(o[]) == 1
        hope(o) != Buffered(1)
        hope(o) != Buffered(2)

        o.commit()
        
        hope(o[]) == 2
        hope(o) == Buffered(2)
        hope.true(o.__o == (2, 2)) // internal
    }
    
    func test_Buffered_JSON() {
        
        let json: JSON = ["a": 1, "b": [2, 3]]
        let b1: JSON.Path = ["b", 1]
        
        let o = Buffered(json)
        
        o[b1] = "✅"
        
        hope(o[b1]) == 3
        hope(o[]) == json

        o.commit()
        
        hope(o[b1]) == "✅"
        hope(o[]) == ["a": 1, "b": [2, "✅"]]
    }
}

