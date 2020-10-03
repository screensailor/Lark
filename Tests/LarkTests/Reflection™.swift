class Reflection™: Hopes {
    
    struct My {
        var a: A
        var a2: A
        var int: Int
        struct A {
            var b: B
            var b2: B
            var int: Int
            struct B {
                var c: C
                var c2: C
                var int: Int
                struct C {
                    var ints: [Int?]
                    var ints2: [Int]?
                    var string: String?
                    var bool = false
                    var url: URL? // ← recursive
                }
            }
        }
    }

    func test() throws {
        
        for o in Reflection.allNamedKeyPaths(in: My.self) {
            print("✅", o.breadcrumbs.joined(separator: "."), ":", type(of: o.keyPath).valueType)
        }
    }
}

/*
 Prints:
 
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
