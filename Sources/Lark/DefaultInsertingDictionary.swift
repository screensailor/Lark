@dynamicMemberLookup
public struct DefaultInsertingDictionary<Key, Value>
where Key: Hashable
{
    public private(set) var dictionary: [Key: Value]
    public let `default`: () -> Value
    
    public init(
        _ dictionary: [Key: Value] = [:],
        default ƒ: @escaping @autoclosure () -> Value
    ) {
        self.dictionary = dictionary
        self.default = ƒ
    }
}

extension DefaultInsertingDictionary {
    
    public subscript(key: Key) -> Value {
        mutating get {
            if let value = dictionary[key] {
                return value
            } else {
                let value = self.default()
                dictionary[key] = value
                return value
            }
        }
        set {
            dictionary[key] = newValue
        }
    }
}

extension DefaultInsertingDictionary {
    
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
    public func inserting(default ƒ: @escaping @autoclosure () -> Value) -> DefaultInsertingDictionary<Key, Value> {
        .init(self, default: ƒ())
    }
}
