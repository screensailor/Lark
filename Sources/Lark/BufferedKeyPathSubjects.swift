///- Note:
/// TODO: `@propertyWrapper public struct PublishedBufferedKeyPaths<Value>`
/// (see ``Combine.Published``)
@dynamicMemberLookup
public final class BufferedKeyPathSubjects<Value> {
    public var published: Subject { .init(self) }
    
    // TODO: atomic r/w
    public private(set) var root: Buffered<Value>
    private var paths: [KeyPath<Value, Value>: CurrentValueSubject<Value, Never>] = [:]
    private var updated: [KeyPath<Value, Value>] = []
    
    public init(_ root: Value) { self.root = Buffered(root) }
    
    public subscript(dynamicMember path: WritableKeyPath<Value, Value>) -> Value {
        get {
            root.__o.0[keyPath: path]
        }
        set {
            root.__o.1[keyPath: path] = newValue
            updated.append(path)
        }
    }
    
    public func commit() {
        root.commit()
        for path in updated {
            paths[path]?.send(root.__o.0[keyPath: path])
        }
        updated.removeAll(keepingCapacity: true)
    }
    
    @dynamicMemberLookup
    public struct Subject {
        
        private let __o: BufferedKeyPathSubjects
        
        init(_ o: BufferedKeyPathSubjects) { __o = o }
        
        public subscript(dynamicMember path: WritableKeyPath<Value, Value>) -> CurrentValueSubject<Value, Never> {
            __o.paths[path] ?? {
                let o = CurrentValueSubject<Value, Never>(__o.root.__o.0[keyPath: path])
                __o.paths[path] = o // TODO: reference counting and removing at zero
                return o
            }()
        }
    }
}
