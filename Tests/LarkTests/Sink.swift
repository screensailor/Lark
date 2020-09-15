import Lark
import Hope

class Sink™: Hopes {
    
    @Published private var json: JSON = .empty
    
    func test_1() {
        
        let o = Sink.Optional<JSON>()
        
        let x: JSON.Path = ["a", "b", 3]
        
        o ...= $json[x]
        
        hope(o[]) == nil
        
        json[x] = "c"
        
        hope(o[]) == "c"
    }
    
    func test_2() throws {
        
        let o = Sink.Result(0)

        let x = $json["a", "b", 3].as(Int.self)
        let y = $json["somewhere", "else"].as(Int.self)
        
        o ...= x.combineLatest(y).map(+)

        try hope(o[].get()) == 0
        
        json["a", "b", 3] = 4
        
        try hope(o[].get()) == 0

        json["somewhere", "else"] = 12

        try hope(o[].get()) == 16
    }
}
