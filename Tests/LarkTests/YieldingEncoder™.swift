class YieldingEncoder™: Hopes {
    
    func test() throws {
        struct My: Codable {
            var a = A()
            var a2 = A()
            struct A: Codable {
                var b = B()
                var b2 = B()
                struct B: Codable {
                    var c = C()
                    var c2 = C()
                    struct C: Codable {
                        var ints: [Int] = [1,2,3]
                        var ints2: [Int] = [1,2,3]
                    }
                }
            }
        }
        
        let expected = [
            ["a"] ,
            ["a", "b"] ,
            ["a", "b", "c"] ,
            ["a", "b", "c", "ints"] ,
            ["a", "b", "c", "ints", "0"] ,
            ["a", "b", "c", "ints", "1"] ,
            ["a", "b", "c", "ints", "2"] ,
            ["a", "b", "c", "ints2"] ,
            ["a", "b", "c", "ints2", "0"] ,
            ["a", "b", "c", "ints2", "1"] ,
            ["a", "b", "c", "ints2", "2"] ,
            ["a", "b", "c2"] ,
            ["a", "b", "c2", "ints"] ,
            ["a", "b", "c2", "ints", "0"] ,
            ["a", "b", "c2", "ints", "1"] ,
            ["a", "b", "c2", "ints", "2"] ,
            ["a", "b", "c2", "ints2"] ,
            ["a", "b", "c2", "ints2", "0"] ,
            ["a", "b", "c2", "ints2", "1"] ,
            ["a", "b", "c2", "ints2", "2"] ,
            ["a", "b2"] ,
            ["a", "b2", "c"] ,
            ["a", "b2", "c", "ints"] ,
            ["a", "b2", "c", "ints", "0"] ,
            ["a", "b2", "c", "ints", "1"] ,
            ["a", "b2", "c", "ints", "2"] ,
            ["a", "b2", "c", "ints2"] ,
            ["a", "b2", "c", "ints2", "0"] ,
            ["a", "b2", "c", "ints2", "1"] ,
            ["a", "b2", "c", "ints2", "2"] ,
            ["a", "b2", "c2"] ,
            ["a", "b2", "c2", "ints"] ,
            ["a", "b2", "c2", "ints", "0"] ,
            ["a", "b2", "c2", "ints", "1"] ,
            ["a", "b2", "c2", "ints", "2"] ,
            ["a", "b2", "c2", "ints2"] ,
            ["a", "b2", "c2", "ints2", "0"] ,
            ["a", "b2", "c2", "ints2", "1"] ,
            ["a", "b2", "c2", "ints2", "2"] ,
            ["a2"] ,
            ["a2", "b"] ,
            ["a2", "b", "c"] ,
            ["a2", "b", "c", "ints"] ,
            ["a2", "b", "c", "ints", "0"] ,
            ["a2", "b", "c", "ints", "1"] ,
            ["a2", "b", "c", "ints", "2"] ,
            ["a2", "b", "c", "ints2"] ,
            ["a2", "b", "c", "ints2", "0"] ,
            ["a2", "b", "c", "ints2", "1"] ,
            ["a2", "b", "c", "ints2", "2"] ,
            ["a2", "b", "c2"] ,
            ["a2", "b", "c2", "ints"] ,
            ["a2", "b", "c2", "ints", "0"] ,
            ["a2", "b", "c2", "ints", "1"] ,
            ["a2", "b", "c2", "ints", "2"] ,
            ["a2", "b", "c2", "ints2"] ,
            ["a2", "b", "c2", "ints2", "0"] ,
            ["a2", "b", "c2", "ints2", "1"] ,
            ["a2", "b", "c2", "ints2", "2"] ,
            ["a2", "b2"] ,
            ["a2", "b2", "c"] ,
            ["a2", "b2", "c", "ints"] ,
            ["a2", "b2", "c", "ints", "0"] ,
            ["a2", "b2", "c", "ints", "1"] ,
            ["a2", "b2", "c", "ints", "2"] ,
            ["a2", "b2", "c", "ints2"] ,
            ["a2", "b2", "c", "ints2", "0"] ,
            ["a2", "b2", "c", "ints2", "1"] ,
            ["a2", "b2", "c", "ints2", "2"] ,
            ["a2", "b2", "c2"] ,
            ["a2", "b2", "c2", "ints"] ,
            ["a2", "b2", "c2", "ints", "0"] ,
            ["a2", "b2", "c2", "ints", "1"] ,
            ["a2", "b2", "c2", "ints", "2"] ,
            ["a2", "b2", "c2", "ints2"] ,
            ["a2", "b2", "c2", "ints2", "0"] ,
            ["a2", "b2", "c2", "ints2", "1"] ,
            ["a2", "b2", "c2", "ints2", "2"] ,
        ]
        
        var actual: [[String]] = []
        
        try My().encode{ path in
            actual.append(path.map(\.stringValue))
        }
        
        hope(actual) == expected
    }
}
