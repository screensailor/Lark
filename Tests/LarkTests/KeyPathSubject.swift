import Lark
import Hope

class KeyPathSubject™: Hopes {
    
    func test() {
        
        let store: CurrentValueSubject<[String: Any], Never> = .init([:])
        
//        let o1 = store.map(\.["a", 1])
        
        
    }
}

private class KeyPathSubject<Store> {
    
    private let store: CurrentValueSubject<Store, Never>
    
    init(_ store: Store) { self.store = .init(store) }
    
}


//private extension Dictionary where Value == Any {
//
//    subscript(path: IntOrString...) -> JSON? {
//        get { self[path] }
//        set { self[path] = newValue }
//    }
//
//    subscript(path: Path) -> JSON? {
//        get {
//            if path.isEmpty { return self }
//            fatalError()
//        }
//        set {
//            guard !path.isEmpty else {
//                value = newValue?.value ?? JSONNull
//                return
//            }
//        }
//    }
//}
