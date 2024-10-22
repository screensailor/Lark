class ReflectingNamedKeyPaths™: Hopes {
    
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
                    var dictionary: [String: Int] = [
                        "one": 1,
                        "two": 2
                    ]
                }
            }
        }
    }

    func test() throws {
        
        let my = My()
        
        let int: String = try my["a", "b", "c", "string"].hopefully()

        hope(int) == "👍"
    }

    func test_self() throws {
        
        var my = My()
        
        my.a.b.c.int = 5
        
        let ohMy: My = try my[].hopefully()

        hope(ohMy.a.b.c.int) == 5
    }

    func test_dictionary() throws {
        
        let my = My()
        
        let int: Int = try my["a", "b", "c", "dictionary", as: [String: Int].self].hopefully()["one"].hopefully()

        hope(int) == 1
    }

    func test_mutation() throws {
        
        var my = My()
        
        let k = try My.writableKeyPath("a", "b", "c", "int", to: Int.self)
        
        my.a.b.c.int = 3
        
        my[keyPath: k] *= 2

        hope(my.a.b.c.int) == 6
    }
    
    func test_point() throws {
        
        var p = CGPoint(x: 2, y: 4)

        do {
            let k = try CGPoint.writableKeyPath("x", to: CGFloat.self)
            
            p[keyPath: k] = 3
            
            hope(p.x) == 3
        }
    }
}

extension CGPoint: ReflectingNamedKeyPaths {
    
    public static let reflected = Self.reflectedNamedKeyPaths()
}

#if os(iOS)
import UIKit

//extension UIButton: ReflectingNamedKeyPaths {
//
//    public static let reflected = Self.reflectedNamedKeyPaths()
//}
#endif
