import Lark
import Hope

class Sink™: Hopes {
    
    @Published private var json: JSON = .empty
    
    func test_1() {
        
        let o = Sink.Optional<JSON>()
        
        let x: JSON.Path = ["a", "b", 3]
        
        o ...= $json[x]
        
        hope(o.value) == nil
        
        json[x] = "c"
        
        hope(o.value) == "c"
    }
    
    func test_2() {
        
        let o = Sink.Result(0)

        let x = $json["a", "b", 3].as(Int.self)
        let y = $json["somewhere", "else"].as(Int.self)
        
        o ...= x.combineLatest(y).map(+)

        hope(o.value) == 0
        
        json["a", "b", 3] = 4
        
        hope(o.value) == 0

        json["somewhere", "else"] = 12

        hope(o.value) == 16
    }
}
