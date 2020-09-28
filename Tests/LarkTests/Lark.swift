@_exported import SE0000_KeyPathReflection
@_exported import Echo
@_exported import Peek
@_exported import Hope
@_exported import Lark

class Lark™: Hopes {
    
    func test() {
        
    }
    
    func test_echo() {
        
        struct My {
            let a: A
            struct A {
                let b: B
                struct B {
                    let c: C
                    struct C {}
                }
            }
        }
        
        let o = (\My.a.b.c).keyPathObject
        hope(o.description) == #"\My.a.b.c"#
    }
    
    func test_reflection() throws {
        
        struct Dog {
            let age: Int
            let name: String
        }
        
        let dog = Reflection.allKeyPaths(for: Dog.self)
        
        let sparky = Dog(age: 128, name: "Sparky")
        
        let values: [JSON] = try dog.map{ k in
            try JSON(sparky[keyPath: k])
        }
        
        hope(values) == [128, "Sparky"]
    }
    
    func test_reflection_Metadata() throws {
        
        struct Dog {
            
            let age: Int
            let name: String
            let bone: Bone
            
            struct Bone {
                let big: Bool
            }
        }
        
        let o = Reflection.allNamedKeyPaths(for: Dog.self).map(\.name)
        
        hope(o) == ["age", "name", "bone"]
    }
}

