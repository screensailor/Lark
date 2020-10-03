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
    }

    func test() throws {
        
        let my = try My.defaultDecodingValue()
        
        let k = try My.keyPaths[["a", "b", "c", "bool"]].hopefully()
        
        let bool = my[keyPath: k] as? Bool
        
        hope(bool) == false // the default value of Bool
    }
}

/*
 ✅ a : A
 ✅ a.b : B
 ✅ a.b.c : C
 ✅ a.b.c.ints : Array<Optional<Int>>
 ✅ a.b.c.ints2 : Optional<Array<Int>>
 ✅ a.b.c.string : Optional<String>
 ✅ a.b.c.bool : Bool
 ✅ a.b.c.url : Optional<URL>
 ✅ a.b.c2 : C
 ✅ a.b.c2.ints : Array<Optional<Int>>
 ✅ a.b.c2.ints2 : Optional<Array<Int>>
 ✅ a.b.c2.string : Optional<String>
 ✅ a.b.c2.bool : Bool
 ✅ a.b.c2.url : Optional<URL>
 ✅ a.b.int : Int
 ✅ a.b2 : B
 ✅ a.b2.c : C
 ✅ a.b2.c.ints : Array<Optional<Int>>
 ✅ a.b2.c.ints2 : Optional<Array<Int>>
 ✅ a.b2.c.string : Optional<String>
 ✅ a.b2.c.bool : Bool
 ✅ a.b2.c.url : Optional<URL>
 ✅ a.b2.c2 : C
 ✅ a.b2.c2.ints : Array<Optional<Int>>
 ✅ a.b2.c2.ints2 : Optional<Array<Int>>
 ✅ a.b2.c2.string : Optional<String>
 ✅ a.b2.c2.bool : Bool
 ✅ a.b2.c2.url : Optional<URL>
 ✅ a.b2.int : Int
 ✅ a.int : Int
 ✅ a2 : A
 ✅ a2.b : B
 ✅ a2.b.c : C
 ✅ a2.b.c.ints : Array<Optional<Int>>
 ✅ a2.b.c.ints2 : Optional<Array<Int>>
 ✅ a2.b.c.string : Optional<String>
 ✅ a2.b.c.bool : Bool
 ✅ a2.b.c.url : Optional<URL>
 ✅ a2.b.c2 : C
 ✅ a2.b.c2.ints : Array<Optional<Int>>
 ✅ a2.b.c2.ints2 : Optional<Array<Int>>
 ✅ a2.b.c2.string : Optional<String>
 ✅ a2.b.c2.bool : Bool
 ✅ a2.b.c2.url : Optional<URL>
 ✅ a2.b.int : Int
 ✅ a2.b2 : B
 ✅ a2.b2.c : C
 ✅ a2.b2.c.ints : Array<Optional<Int>>
 ✅ a2.b2.c.ints2 : Optional<Array<Int>>
 ✅ a2.b2.c.string : Optional<String>
 ✅ a2.b2.c.bool : Bool
 ✅ a2.b2.c.url : Optional<URL>
 ✅ a2.b2.c2 : C
 ✅ a2.b2.c2.ints : Array<Optional<Int>>
 ✅ a2.b2.c2.ints2 : Optional<Array<Int>>
 ✅ a2.b2.c2.string : Optional<String>
 ✅ a2.b2.c2.bool : Bool
 ✅ a2.b2.c2.url : Optional<URL>
 ✅ a2.b2.int : Int
 ✅ a2.int : Int
 ✅ int : Int

 */
