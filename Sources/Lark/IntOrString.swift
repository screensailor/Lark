public enum IntOrString: Hashable {
    case int(Int)
    case string(String)
}

extension IntOrString: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .int(try container.decode(Int.self))
        } catch {
            self = try .string(container.decode(String.self))
        }
    }
}

extension IntOrString: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .int(o): try container.encode(o)
        case let .string(o): try container.encode(o)
        }
    }
}

extension IntOrString: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .int(o): return String(describing: o)
        case let .string(o): return o
        }
    }
}

extension IntOrString: CodingKey {
    
    @inlinable public var stringValue: String { debugDescription }
    @inlinable public init?(stringValue: String) { self = .string(stringValue) }
    
    @inlinable public var intValue: Int? { if case let .int(o) = self { return o } else  { return nil } }
    @inlinable public init?(intValue: Int) { self = .int(intValue) }
}

extension IntOrString: ExpressibleByStringLiteral {
    @inlinable public init(stringLiteral value: String) { self = .string(value) }
}

extension IntOrString: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: IntegerLiteralType) { self = .int(value) }
}

extension Collection where Element == IntOrString {
    
    @inlinable public func joined(separator: String = ".") -> String {
        map(\.debugDescription).joined(separator: separator)
    }
}
