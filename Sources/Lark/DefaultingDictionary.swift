@dynamicMemberLookup
public struct DefaultingDictionary<Key, Value>
where Key: Hashable
{
    public private(set) var dictionary: [Key: Value]
    public var `default`: (Key) -> Value
    
    public init(
        _ dictionary: [Key: Value] = [:],
        default ƒ: @escaping (Key) -> Value
    ) {
        self.dictionary = dictionary
        self.default = ƒ
    }
    
    public init(
        _ dictionary: [Key: Value] = [:],
        default ƒ: @escaping @autoclosure () -> Value
    ) {
        self.init(dictionary){_ in ƒ() }
    }
}

extension DefaultingDictionary {
    
    public subscript<A>(dynamicMember path: KeyPath<[Key: Value], A>) -> A {
        dictionary[keyPath: path]
    }

    public subscript(key: Key) -> Value {
        get { dictionary[key] ?? self.default(key) }
        set { dictionary[key] = newValue }
    }

    public subscript() -> [Key: Value] {
        get{ dictionary }
        set{ dictionary = newValue }
    }
}

extension Dictionary {
    
    @inlinable
    public func defaulting(to ƒ: @escaping (Key) -> Value) -> DefaultingDictionary<Key, Value> {
        .init(self, default: ƒ)
    }
    
    @inlinable
    public func defaulting(to ƒ: @escaping @autoclosure () -> Value) -> DefaultingDictionary<Key, Value> {
        .init(self, default: {_ in ƒ() })
    }
}
