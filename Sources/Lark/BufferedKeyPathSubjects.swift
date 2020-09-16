///- Note:
/// TODO: `@propertyWrapper public struct PublishedBufferedKeyPaths<Value>`
/// (see ``Combine.Published``)
@dynamicMemberLookup
public final class BufferedKeyPathSubjects<Value> {
    
    public var published: Subjects { .init(self) }
    
    // TODO: atomic r/w
    public private(set) var root: Buffered<Value>
    private var subjects: [PartialKeyPath<Value>: Subject] = [:]
    private var updated: Set<PartialKeyPath<Value>> = [] // TODO: sequential as well as unuque
    
    public init(_ root: Value) { self.root = Buffered(root) }
    
    public subscript<A>(dynamicMember path: WritableKeyPath<Value, A>) -> A {
        get {
            root.__o.0[keyPath: path]
        }
        set {
            root.__o.1[keyPath: path] = newValue
            updated.insert(path)
        }
    }
    
    public func commit() {
        root.commit()
        let value = root[]
        for path in updated {
            subjects[path]?.send(value)
        }
        updated.removeAll(keepingCapacity: true)
    }
    
    private struct Subject {
        let reference: Any
        let send: (Value) -> ()
    }
    
    @dynamicMemberLookup
    public struct Subjects {
        
        private let __o: BufferedKeyPathSubjects
        
        init(_ o: BufferedKeyPathSubjects) { __o = o }
        
        public subscript<A>(dynamicMember path: WritableKeyPath<Value, A>) -> CurrentValueSubject<A, Never> {
            __o.subjects[path]?.reference as? CurrentValueSubject<A, Never> ?? {
                let subject = CurrentValueSubject<A, Never>(__o.root.__o.0[keyPath: path])
                let o = Subject(
                    reference: subject,
                    send: { value in subject.send(value[keyPath: path]) }
                )
                __o.subjects[path] = o // TODO: reference counting and removing at zero
                return subject
            }()
        }
    }
}
