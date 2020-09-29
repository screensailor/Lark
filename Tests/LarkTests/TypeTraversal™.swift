var state: [String: Any] = [:]

struct X<T> {
    let api: String
    var value: T
}

@propertyWrapper
struct A<T> {
    
    let api: String
    
    var wrappedValue: X<T> {
        get {
            X(api: api, value: state[api] as! T)
        }
        set {
            state[api] = newValue.value
        }
    }
    
    init(wrappedValue: X<T>) {
        self.api = wrappedValue.api
        self.wrappedValue = wrappedValue
    }
}

func | <T>(l: T, r: String) -> X<T> { X(api: r, value: l) }

class O: Hashable {
    static func == (l: O, r: O) -> Bool { l === r }
    func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}

class Ω: O {}
class ƒ: O {}

typealias Api = Encodable

enum x {
    
    static let app = App()
    
    class App: Ω, Api {
        let scene = Scene()
    }
    
    class Scene: Ω_Node, Api {
        let selected = Node()
        let bounds = Node()
    }
    
    class Node: Ω_Node, Api {}
    
    class Ω_Node: Ω {
        let background = Color()
        let scale = Scale()
        let children = Sequence()
    }
    
    class Color: Ω, Api {}
    class Scale: Ω, Api {}
    
    class Sequence: Ω_Sequence, Api {}
    
    class Ω_Sequence: Ω {
        let first = First()
        class First: Ω, Api {}
    }
}

class TypeTraversalTests: XCTestCase {
    
    @A var int: X<Int> = 2 | "scene.children.count"
    
    @A var ƒ: X<(Int) -> Int> = { $0 * 2 } | "ƒ"
    
    func test() throws {
        
        hope(self.ƒ.value(self.int.value)) == 4
        
        try x.app.encode{ path in
//            guard node is O else { return }
            print(path.map(\.stringValue))
        }
    }
}

