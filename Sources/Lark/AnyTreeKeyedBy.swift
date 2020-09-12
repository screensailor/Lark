import Peek

public enum JSONLeaf: Equatable {
    case null
    case boolean(Bool)
    case number(Double)
    case string(String)
}

public typealias JSON = Tree<String, JSONLeaf>

extension JSON: ExpressibleByBooleanLiteral {
    @inlinable public init(booleanLiteral value: Bool) { self = .leaf(.boolean(value)) }
}

extension JSON: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: Int) { self = .leaf(.number(Double(value))) }
}

extension JSON: ExpressibleByFloatLiteral {
    @inlinable public init(floatLiteral value: Double) { self = .leaf(.number(value)) }
}

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .leaf(.string(value)) }
}

extension JSON: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: String) { self = .leaf(.string(value)) }
}

extension JSON: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: String) { self = .leaf(.string(value)) }
}

public indirect enum Tree<Key, Leaf> where Key: Hashable {
    case leaf(Leaf)
    case array([Tree])
    case dictionary([Key: Tree])
}
    
extension Tree {
    
    public typealias Index = EitherType<Int, Key>
    
    public static var empty: Tree { .dictionary([:]) }
    
    public init() { self = .empty }
}

extension Tree: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self.init() }
}

extension Tree: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Tree...) { self = .array(elements) }
}

extension Tree: ExpressibleByDictionaryLiteral {
    @inlinable public init(dictionaryLiteral elements: (Key, Tree)...) { self = .dictionary(.init(uniqueKeysWithValues: elements)) }
}

extension Tree {
    
    public var any: Any {
        switch self {
        case let .leaf(o): return o
        case let .array(o): return o
        case let .dictionary(o): return o
        }
    }
    
    public func cast<T>(
        to: T.Type = T.self,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws -> T {
        guard let t = any as? T else {
            throw Error("\(any) is not \(T.self)", function, file, line)
        }
        return t
    }
}

extension Tree {
    
    public init(_ value: Any) throws {
        throw Error()
    }

    @inlinable public subscript(path: Index...) -> Self? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    public subscript(path: [Index]) -> Self? {
        get {
            if path.isEmpty { return self }
            fatalError()
        }
        set {
            guard !path.isEmpty else {
                self = newValue ?? .empty
                return
            }
        }
    }
}

extension Tree: Equatable where Leaf: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.leaf(l), .leaf(r)): return l == r
        case let (.array(l), .array(r)): return l == r
        case let (.dictionary(l), .dictionary(r)): return l == r
        default: return false
        }
    }
}

extension Tree {
    
    public struct Error: Swift.Error, CustomStringConvertible, CustomDebugStringConvertible {
        public var description: String
        @inlinable public var debugDescription: String { description }
        @inlinable init(
            _ description: String = "",
            _ function: String = #function,
            _ file: String = #file,
            _ line: Int = #line
        ){
            self.description = "Tree.Error(\(description) at: \(CodeLocation(function, file, line)))"
        }
    }
}

// MARK: - AnyTreeKeyedBy<Key>

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
