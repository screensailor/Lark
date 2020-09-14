import Peek
import Foundation

public typealias JSON = Tree<String, JSONLeaf>

extension JSON {
    @inlinable public init(_ o: Int) { self = .leaf(.init(o)) }
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
    
    @inlinable public func `as`<T>(_ type: T.Type = T.self) -> AnyPublisher<T, Error> {
        tryMap{ o -> T in try o.cast() }.eraseToAnyPublisher()
    }
}

public enum JSONLeaf: Equatable {
    case null
    case boolean(Bool)
    case number(Double)
    case string(String)
    case error(Peek.Error)
}

extension JSONLeaf: Castable {
    
    @inlinable public init(_: NSNull){ self = .null }
    @inlinable public init(_ o: Bool){ self = .boolean(o) }
    @inlinable public init(_ o: Double){ self = .number(o) }
    @inlinable public init(_ o: String){ self = .string(o) }
    @inlinable public init(_ o: Peek.Error){ self = .error(o) }

    @inlinable public init(_ o: JSONLeaf){ self = o }
    @inlinable public init(_ o: Int){ self = .number(Double(o)) }

    public init<A>(
        _ a: A,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws {
        switch a
        {
        case is NSNull: self = .null
        case let o as Bool: self = .boolean(o)
        case let o as Double: self = .number(o)
        case let o as String: self = .string(o)
        case let o as Peek.Error: self = .error(o)
            
        case let o as JSONLeaf: self = o
        case let o as Int: self = .number(Double(o))
            
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
