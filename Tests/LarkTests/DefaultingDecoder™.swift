import Lark

class DefaultingDecoder™: Hopes {
    
    struct My: Codable {
        var a = A()
        var a2 = A()
        var a3 = 3
        struct A: Codable {
            var b = B()
            var b2 = B()
            var b3 = 3
            struct B: Codable {
                var c = C()
                var c2 = C()
                var c3 = 3
                struct C: Codable {
                    var ints: [Int?] = [1,2,3]
                    var ints2: [Int]? = [1,2,3]
                    var string: String? = "👋"
                    var bool = false
//                    var url: URL? // ← recursive
                }
            }
        }
    }

    func test() throws {
        
        try My.defaultDecodingValue() ¶ "✅"
    }
}
