public typealias IntOrString = EitherType<Int, String>

extension IntOrString {
    @inlinable public var int: Int? { a }
    @inlinable public var string: String? { b }
}

extension IntOrString: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.init(try container.decode(Int.self))
        } catch {
            self.init(try container.decode(String.self))
        }
    }
}

extension IntOrString: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let .a(o): try container.encode(o)
        case let .b(o): try container.encode(o)
        }
    }
}

extension IntOrString {
    public var debugDescription: String {
        switch value {
        case let .a(o): return String(describing: o)
        case let .b(o): return o
        }
    }
}

extension IntOrString: CustomStringConvertible {
    @inlinable public var description: String { debugDescription }
}

extension IntOrString: CodingKey {
    
    @inlinable public var stringValue: String { debugDescription }
    @inlinable public init?(stringValue: String) { self.init(stringValue) }
    
    @inlinable public var intValue: Int? { a }
    @inlinable public init?(intValue: Int) { self.init(intValue) }
}

extension IntOrString: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension IntOrString: ExpressibleByStringLiteral {
    @inlinable public init(stringLiteral value: String) { self.init(value) }
}

extension IntOrString: ExpressibleByUnicodeScalarLiteral {
    @inlinable public init(unicodeScalarLiteral value: String) { self.init(value) }
}

extension IntOrString: ExpressibleByExtendedGraphemeClusterLiteral {
    @inlinable public init(extendedGraphemeClusterLiteral value: String) { self.init(value) }
}

extension Collection where Element == IntOrString {
    
    @inlinable public func joined(separator: String = ".") -> String {
        lazy.map(\.debugDescription).joined(separator: separator)
    }
}
