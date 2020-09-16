///- Note:
/// TODO: `@propertyWrapper public struct PublishedKeyPaths<Value>`
/// (see ``Combine.Published``)
@dynamicMemberLookup
public final class CurrentKeyPathSubjects<A>
where A: ExpressibleByNilLiteral
{
    public var published: Subject { .init(self) }
    
    // TODO: atomic r/w
    public private(set) var root: A
    private var paths: [KeyPath<A, A>: CurrentValueSubject<A, Never>] = [:]
    
    public init(_ root: A) { self.root = root }
    
    public subscript(dynamicMember path: WritableKeyPath<A, A>) -> A {
        get {
            root[keyPath: path]
        }
        set {
            root[keyPath: path] = newValue
            paths[path]?.send(newValue)
        }
    }
    
    @dynamicMemberLookup
    public struct Subject {
        
        private let __o: CurrentKeyPathSubjects
        
        init(_ o: CurrentKeyPathSubjects) { __o = o }
        
        public subscript(dynamicMember path: WritableKeyPath<A, A>) -> CurrentValueSubject<A, Never> {
            __o.paths[path] ?? {
                let o = CurrentValueSubject<A, Never>(__o.root[keyPath: path])
                __o.paths[path] = o // TODO: reference counting and removing at zero
                return o
            }()
        }
    }
}
