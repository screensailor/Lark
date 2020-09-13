import Peek

public enum JSONLeaf: Equatable {
    case null
    case boolean(Bool)
    case number(Double)
    case string(String)
}

extension JSONLeaf: BoxedAny {
    
    @inlinable public var any: Any { unboxedAny }
    
    public var unboxedAny: Any {
        switch self {
        case .null: return NSNull()
        case let .boolean(o): return o
        case let .number(o): return o
        case let .string(o): return o
        }
    }
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

