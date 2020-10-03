class Reflection™: Hopes {
    
    struct My: ReflectingdNamedKeyPaths {
        
        static let reflected = My.reflectedNamedKeyPaths()

        var a = A()
        var a2 = A()
        var int = 0
        struct A {
            var b = B()
            var b2 = B()
            var int = 1
            struct B {
                var c = C()
                var c2 = C()
                var int = 2
                struct C {
                    var int = 3
                    var ints: [Int?] = [nil, 1, 2]
                    var ints2: [Int]?
                    var string: String? = "👍"
                    var url: URL? // ← recursive
                }
            }
        }
    }

    func test() throws {
        
        let my = My()
        
        let int: String = try my["a", "b", "c", "string"].hopefully()

        hope(int) == "👍"
    }
}
