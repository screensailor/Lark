class YieldingDecoder™: Hopes {
    
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
                    var ints: [Int?]
                    var ints2: [Int]?
                    var string: String?
                    var bool = false
//                    var url: URL? // ← recursive
                }
            }
        }
    }

    func test() throws {
        
        let my = try My.byYielding{ type, path, defaultValue in
            print("✅", path.map(\.stringValue).joined(separator: "."), "|", type)
            return try defaultValue()
        }
        
        hope(my.a.b.c.bool) == false
    }
}


/*
 
 prints:
 
 - Note: it currently skips optionals:
 
 ✅ a | A
 ✅ a.b | B
 ✅ a.b.c | C
 ✅ a.b.c.ints | Array<Optional<Int>>
 ✅ a.b.c.ints2 | Array<Int>
 ✅ a.b.c.string | String
 ✅ a.b.c.bool | Bool
 ✅ a.b.c2 | C
 ✅ a.b.c2.ints | Array<Optional<Int>>
 ✅ a.b.c2.ints2 | Array<Int>
 ✅ a.b.c2.string | String
 ✅ a.b.c2.bool | Bool
 ✅ a.b.c3 | Int
 ✅ a.b2 | B
 ✅ a.b2.c | C
 ✅ a.b2.c.ints | Array<Optional<Int>>
 ✅ a.b2.c.ints2 | Array<Int>
 ✅ a.b2.c.string | String
 ✅ a.b2.c.bool | Bool
 ✅ a.b2.c2 | C
 ✅ a.b2.c2.ints | Array<Optional<Int>>
 ✅ a.b2.c2.ints2 | Array<Int>
 ✅ a.b2.c2.string | String
 ✅ a.b2.c2.bool | Bool
 ✅ a.b2.c3 | Int
 ✅ a.b3 | Int
 ✅ a2 | A
 ✅ a2.b | B
 ✅ a2.b.c | C
 ✅ a2.b.c.ints | Array<Optional<Int>>
 ✅ a2.b.c.ints2 | Array<Int>
 ✅ a2.b.c.string | String
 ✅ a2.b.c.bool | Bool
 ✅ a2.b.c2 | C
 ✅ a2.b.c2.ints | Array<Optional<Int>>
 ✅ a2.b.c2.ints2 | Array<Int>
 ✅ a2.b.c2.string | String
 ✅ a2.b.c2.bool | Bool
 ✅ a2.b.c3 | Int
 ✅ a2.b2 | B
 ✅ a2.b2.c | C
 ✅ a2.b2.c.ints | Array<Optional<Int>>
 ✅ a2.b2.c.ints2 | Array<Int>
 ✅ a2.b2.c.string | String
 ✅ a2.b2.c.bool | Bool
 ✅ a2.b2.c2 | C
 ✅ a2.b2.c2.ints | Array<Optional<Int>>
 ✅ a2.b2.c2.ints2 | Array<Int>
 ✅ a2.b2.c2.string | String
 ✅ a2.b2.c2.bool | Bool
 ✅ a2.b2.c3 | Int
 ✅ a2.b3 | Int
 ✅ a3 | Int

 */
