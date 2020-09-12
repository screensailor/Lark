public protocol JSONLeaf: Codable {}
extension Bool: JSONLeaf {}
extension Int: JSONLeaf {}
extension Double: JSONLeaf {}
extension String: JSONLeaf {}

public typealias JSON = Tree<String, JSONLeaf>

extension JSON: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: IntegerLiteralType) { self.init(.leaf(value)) }
}

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self.init(.leaf(value)) }
}

extension JSON: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: String) { self.init(.leaf(value)) }
}

extension JSON: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: String) { self.init(.leaf(value)) }
}

public struct Tree<Key, Leaf> where Key: Hashable {
    
    public typealias Index = EitherType<Int, Key>
    
    private var stored: AnyTreeKeyedBy<Key> = .init()
    
    public init() {}
    
    public init(_ value: Value) { self.value = value }
    
    public init(_ value: Any) throws {
        throw Error()
    }
}

extension Tree {
    
    public struct Error: Swift.Error, CustomStringConvertible, CustomDebugStringConvertible {
        @inlinable public var debugDescription: String { "Tree.Error" }
        @inlinable public var description: String { debugDescription }
    }
}

extension Tree {
    
    public indirect enum Value {
        case leaf(Leaf)
        case array([Value])
        case dictionary([Key: Value])
    }

    public var value: Value {
        get {
            switch stored.value {
            case let o as [Key: Any]: return .dictionary(o as! [Key: Value])
            case let o as [Any]: return .array(o as! [Value])
            case let o: return .leaf(o as! Leaf)
            }
        }
        set {
            switch newValue {
            case let .leaf(o): stored = .init(o)
            case let .array(o): stored = .init(o)
            case let .dictionary(o): stored = .init(o)
            }
        }
    }
}

extension Tree: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self.init() }
}

extension Tree: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Value...) { self.init(.array(elements)) }
}

extension Tree: ExpressibleByDictionaryLiteral {
    @inlinable public init(dictionaryLiteral elements: (Key, Value)...) { self.init(.dictionary(Dictionary(elements){ $1 })) }
}

public struct AnyTreeKeyedBy<Key> where Key: Hashable {
    
    public typealias Index = EitherType<Int, Key>
    
    public private(set) var value: Any
    
    public init() { self.value = [:] }
    public init(_ value: Any) { self.value = value }

    @inlinable public subscript(path: Index...) -> AnyTreeKeyedBy? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    public subscript(path: [Index]) -> AnyTreeKeyedBy? {
        get {
            if path.isEmpty { return self }
            fatalError()
        }
        set {
            guard !path.isEmpty else {
                value = newValue?.value ?? [:]
                return
            }
        }
    }
}

extension AnyTreeKeyedBy: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self.init([:]) }
}

extension AnyTreeKeyedBy: ExpressibleByBooleanLiteral {
    @inlinable public init(booleanLiteral value: BooleanLiteralType) { self.init(value) }
}

extension AnyTreeKeyedBy: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension AnyTreeKeyedBy: ExpressibleByStringLiteral {
    @inlinable public init(stringLiteral value: String) { self.init(value) }
}

extension AnyTreeKeyedBy: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Any...) { self.init(elements) }
}

extension AnyTreeKeyedBy: ExpressibleByDictionaryLiteral {
    @inlinable public init(dictionaryLiteral elements: (String, Any)...) { self.init(Dictionary(elements){ $1 }) }
}



//public let JSONNull: [String: Any] = [:]
//
//public protocol JSONValue {}
//extension Bool: JSONValue {}
//extension Int: JSONValue {}
//extension Double: JSONValue {}
//extension String: JSONValue {}
//
//public protocol JSONCollection: Collection {}
//extension Array: JSONCollection {}
//extension Dictionary: JSONCollection where Key == String {}
//
//public protocol SelflessEquatable {
//    func selflessEqual(to other: Any) -> Bool
//}
//
//extension SelflessEquatable where Self: Equatable {
//    public func selflessEqual(to other: Any) -> Bool {
//        self == (other as? Self)
//    }
//}
//
//extension JSON: Equatable {
//
//    public static func == (l: JSON, r: JSON) -> Bool {
//        if let l = l.value as? [Any], let r = r.value as? [Any] {
//            return l == r
//        }
//        return false
//    }
//}
//
//extension Array where Element == Any {
//
//    public static func == (l: Array, r: Array) -> Bool {
//        guard l.count == r.count else { return false }
//        return zip(l, r).allSatisfy{ l, r in
//            if let l = l as? SelflessEquatable { return l.selflessEqual(to: r) }
//            if let r = r as? SelflessEquatable { return r.selflessEqual(to: l) }
//            return false
//        }
//    }
//}
//
//extension Dictionary where Self == [String: Any] {
//
//    public static func == (l: Dictionary, r: Dictionary) -> Bool {
//        guard l.count == r.count else { return false }
//        return zip(l, r).allSatisfy{ l, r in
//            JSON(l) == JSON(r)
//        }
//    }
//}
