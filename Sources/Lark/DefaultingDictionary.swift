@dynamicMemberLookup
public struct DefaultingDictionary<Key, Value>
where Key: Hashable
{
    public private(set) var dictionary: [Key: Value]
    public var `default`: () -> Value
    
    public init(
        _ dictionary: [Key: Value] = [:],
        default ƒ: @escaping @autoclosure () -> Value
    ) {
        self.dictionary = dictionary
        self.default = ƒ
    }
}

extension DefaultingDictionary {
    
    public subscript(key: Key) -> Value {
        get {
            dictionary[key] ?? self.default()
        }
        set {
            dictionary[key] = newValue
        }
    }
}

extension DefaultingDictionary {
    
    public subscript<A>(dynamicMember path: KeyPath<[Key: Value], A>) -> A {
        dictionary[keyPath: path]
    }
    
    public subscript() -> [Key: Value] {
        get{ dictionary }
        set{ dictionary = newValue }
    }
}

extension Dictionary {
    
    @inlinable
    public func defaulting(to ƒ: @escaping @autoclosure () -> Value) -> DefaultInsertingDictionary<Key, Value> {
        .init(self, default: ƒ())
    }
}
