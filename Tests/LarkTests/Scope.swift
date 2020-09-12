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
        
        let result = Sink.Var(0.0)
        
        let xPath: [JSON.Index] = ["a", "b", 3]
        let yPath: [JSON.Index] = [3, 2, 1]

        let x = $json.map(\.[xPath]).tryCompactMap{ try $0?.cast(to: Double.self) }
        let y = $json.map(\.[yPath]).tryCompactMap{ try $0?.cast(to: Double.self) }
        
        let z = x.combineLatest(y).map(+)
        
        result ...= z / bag

        hope(result.value) == 0
        
        json[xPath] = 4
        
        hope(result.value) == 0

        json[yPath] = 12

        hope(result.value) == 16
    }
}
