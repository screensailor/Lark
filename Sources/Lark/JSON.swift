import Peek
import Foundation

public enum JSONLeaf: Equatable {
    case null
    case boolean(Bool)
    case number(Double)
    case string(String)
    case error(Peek.Error)
}

extension JSONLeaf: Leaf {
    
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

extension JSONLeaf: BoxedAny {
    
    @inlinable public var any: Any { unboxedAny }
    
    public var unboxedAny: Any {
        switch self {
        case .null: return NSNull()
        case let .boolean(o): return o
        case let .number(o): return o
        case let .string(o): return o
        case let .error(o): return o
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
