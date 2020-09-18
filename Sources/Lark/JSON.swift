import Foundation

public typealias JSON = Tree<String, JSONLeaf>

extension JSON {
    @inlinable public init() { self = .leaf(.null) }
    @inlinable public init(_ o: NSNull) { self = .leaf(.null) }
    @inlinable public init(_ o: Bool) { self = .leaf(.boolean(o)) }
    @inlinable public init(_ o: Int) { self = .leaf(.number(Double(o))) }
    @inlinable public init(_ o: Double) { self = .leaf(.number(o)) }
    @inlinable public init(_ o: String) { self = .leaf(.string(o)) }
    @inlinable public init(_ o: BrainError) { self = .leaf(.error(o)) }
}

extension CustomDebugStringConvertible {
    @inlinable public init(
        _ o: JSON,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws {
        self = try o.cast(function, file, line)
    }
}

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

extension Publisher where Output == JSON {
    
    @inlinable public subscript(path: JSON.Index...) -> AnyPublisher<JSON, Failure> {
        self[path]
    }
    
    @inlinable public subscript(path: JSON.Path) -> AnyPublisher<JSON, Failure> {
        compactMap{ $0[path] }.eraseToAnyPublisher()
    }
    
    @inlinable public func `as`<T>(
        _ type: T.Type = T.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> AnyPublisher<T, Error> {
        tryMap{ o -> T in try o.cast(function, file, line) }.eraseToAnyPublisher()
    }
    
    @inlinable public func `when`<T>(
        _ type: T.Type = T.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> AnyPublisher<T, Failure> {
        compactMap{ o -> T? in try? o.cast(to: T.self, function, file, line) }.eraseToAnyPublisher()
    }
}

public enum JSONLeaf: Equatable {
    case null
    case boolean(Bool)
    case number(Double)
    case string(String)
    case error(BrainError)
}

extension JSONLeaf: ExpressibleByErrorValue {
    
    @inlinable public var isError: Bool {
        if case .error = self { return  true } else { return false }
    }
}

extension JSONLeaf: Castable {
    
    @inlinable public init(_: NSNull){ self = .null }
    @inlinable public init(_ o: Bool){ self = .boolean(o) }
    @inlinable public init(_ o: Double){ self = .number(o) }
    @inlinable public init(_ o: String){ self = .string(o) }
    @inlinable public init(_ o: BrainError){ self = .error(o) }

    @inlinable public init(_ o: JSONLeaf){ self = o }
    @inlinable public init(_ o: Int){ self = .number(Double(o)) }

    public static func from<A>(
        _ a: A,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> JSONLeaf {
        switch a
        {
        case is NSNull: return .null
        case let o as Bool: return .boolean(o)
        case let o as Double: return .number(o)
        case let o as String: return .string(o)
        case let o as BrainError: return .error(o)
            
        case let o as JSONLeaf: return o
        case let o as Int: return .number(Double(o))
            
        default: throw "\(a) could not be converted to \(Self.self)".error(function, file, line)
        }
    }

    public func cast<A>(
        to: A.Type = A.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        switch self
        {
        case let .boolean(o as A): return o
        case let .number(o as A): return o
        case let .string(o as A): return o
        case let .error(o as A): return o
        case let .error(o): throw o
            
        case .null where A.self is NSNull.Type:
            return NSNull() as! A
            
        case let .number(o) where A.self is Int.Type:
            if let o = Int(exactly: o) { return o as! A }
            
        // TODO: ...
            
        default: break
        }
        throw "\(self) is not \(A.self)".error(function, file, line)
    }

}

extension JSONLeaf: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self = .null }
}

extension JSONLeaf: ExpressibleByBooleanLiteral {
    @inlinable public init(booleanLiteral value: Bool) { self = .boolean(value) }
}

extension JSONLeaf: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: Int) { self = .number(Double(value)) }
}

extension JSONLeaf: ExpressibleByFloatLiteral {
    @inlinable public init(floatLiteral value: Double) { self = .number(value) }
}

extension JSONLeaf: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
}

extension JSONLeaf: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: String) { self = .string(value) }
}

extension JSONLeaf: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: String) { self = .string(value) }
}

extension JSONLeaf: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .null: return "null"
        case let .boolean(o): return String(describing: o)
        case let .number(o): return String(describing: o)
        case let .string(o): return o
        case let .error(o): return String(describing: o)
        }
    }
}

extension JSONLeaf: CustomStringConvertible {
    @inlinable public var description: String { debugDescription }
}
