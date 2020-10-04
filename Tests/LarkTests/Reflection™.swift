class Reflection™: Hopes {
    
    struct My: ReflectingNamedKeyPaths {
        
        static let reflected = Self.reflectedNamedKeyPaths() // TODO: remove this protocol requirement

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

    func test_mutation() throws {
        
        var my = My()
        
        let k = try My.reflected.keyPaths[["a", "b", "c", "int"]].hopefully()
        
        let w = try (k as? WritableKeyPath<My, Int>).hopefully()
        
        my.a.b.c.int = 3
        
        my[keyPath: w] *= 2

        hope(my.a.b.c.int) == 6
    }
}
