@dynamicMemberLookup
final public class Buffered<Value> {
    
    @usableFromInline var pair: (Value, Value)
    
    @inlinable public init(_ value: Value) { pair = (value, value) }
}

extension Buffered {
    @inlinable public var value: Value { get { pair.0 } set { pair.1 = newValue } }
}

extension Buffered {
    @inlinable public var committed: Buffered { .init(pair.1) }
    @inlinable public func commit() { pair = (pair.1, pair.1) }
}

extension Buffered {
    
    @inlinable public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> A {
        get { pair.0[keyPath: keyPath] }
        set { pair.1[keyPath: keyPath] = newValue }
    }
}

extension Buffered: Equatable where Value: Equatable {
    
    @inlinable public static func == (lhs: Buffered<Value>, rhs: Buffered<Value>) -> Bool {
        lhs.pair == rhs.pair
    }
    
    @inlinable public static func == (lhs: Buffered<Value>, rhs: (Value, Value)) -> Bool {
        lhs.pair == rhs
    }
    
    @inlinable public static func == (lhs: (Value, Value), rhs: Buffered<Value>) -> Bool {
        lhs == rhs.pair
    }
}

extension Buffered: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(Buffered.self)(\(pair))"
    }
}
