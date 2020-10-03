class Reflection™: Hopes {
    
    struct My: Codable {
        var a: A
        var a2: A
        var int: Int
        struct A: Codable {
            var b: B
            var b2: B
            var int: Int
            struct B: Codable {
                var c: C
                var c2: C
                var int: Int
                struct C: Codable {
                    var int: Int
                    var ints: [Int?]
                    var ints2: [Int]?
                    var string: String?
                    var bool: Bool
                    var url: URL? // ← recursive
                }
            }
        }
        
        static let reflected = Reflection.keyPathsAndBreadcrumbs(in: My.self)
        
        subscript<A>(breadcrumb: String..., as type: A.Type = A.self) -> A? {
            guard !breadcrumb.isEmpty else { return self as? A }
            guard let k = My.reflected.keyPaths[breadcrumb] else { return nil }
            return self[keyPath: k] as? A
        }
    }

    func test() throws {
        
        var my = try My.defaultDecodingValue()
        
        my.a.b.c.int = 3
        
        let int: Int = try my["a", "b", "c", "int"].hopefully()

        hope(int) == 3
    }
}
