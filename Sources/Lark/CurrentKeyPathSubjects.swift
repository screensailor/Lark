///- Note:
/// TODO: `@propertyWrapper public struct PublishedKeyPaths<Value>`
/// (see ``Combine.Published``)
@dynamicMemberLookup
public final class CurrentKeyPathSubjects<Value> {
    
    public var published: Subjects { .init(self) }
    
    // TODO: atomic r/w
    public private(set) var value: Value
    private var subjects: [PartialKeyPath<Value>: Subject] = [:]
    
    public init(_ value: Value) { self.value = value }
    
    public subscript<A>(dynamicMember path: WritableKeyPath<Value, A>) -> A {
        get {
            value[keyPath: path]
        }
        set {
            value[keyPath: path] = newValue
            subjects[path]?.send(value)
        }
    }
    
    private struct Subject {
        let reference: Any
        let send: (Value) -> ()
    }
    
    @dynamicMemberLookup
    public struct Subjects {
        
        private let __o: CurrentKeyPathSubjects
        
        init(_ o: CurrentKeyPathSubjects) { __o = o }
        
        public subscript<A>(dynamicMember path: WritableKeyPath<Value, A>) -> CurrentValueSubject<A, Never> {
            __o.subjects[path]?.reference as? CurrentValueSubject<A, Never> ?? {
                let subject = CurrentValueSubject<A, Never>(__o.value[keyPath: path])
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
