class DefaultingDecoder™: Hopes {
    
    struct My: Codable, Equatable {
        var a = A()
        var a2 = A()
        var a3 = 0
        struct A: Codable, Equatable {
            var b = B()
            var b2 = B()
            var b3 = 0
            struct B: Codable, Equatable {
                var c = C()
                var c2 = C()
                var c3 = 0
                struct C: Codable, Equatable {
                    var ints: [Int?] = []
                    var ints2: [Int]?
                    var string: String?
                    var bool = false
                    var url: URL? // ← recursive
                }
            }
        }
    }

    func test() throws {
        let o = try My.defaultDecodingValue()
        hope(o) == My()
    }
}
