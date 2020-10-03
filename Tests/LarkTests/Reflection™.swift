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
        
        static let breadcrumbs = Reflection.breadcrumbs(in: My.self)
        static let keyPaths = Dictionary(breadcrumbs.map{ ($1, $0) }){ $1 }
        
        subscript<A>(breadcrumb: String..., as type: A.Type = A.self) -> A? {
            guard !breadcrumb.isEmpty else { return self as? A }
            guard let k = My.keyPaths[breadcrumb] else { return nil }
            return self[keyPath: k] as? A
        }
    }

    func test() throws {
        
        let my = try My.defaultDecodingValue()
        
        let int: Int = try my["a", "b", "c", "int"].hopefully()

        hope(int) == 0
    }
}
