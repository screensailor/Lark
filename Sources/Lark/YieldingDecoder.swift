/// TODO: optionals❗️
/// TODO: isRecursive❗️
/// TODO: YieldingDecoderIterator

public typealias YieldingDecoderClosure = (
    _ type: Any.Type,
    _ path: [CodingKey],
    _ defaultValue: () throws -> Any
) throws -> Any

public extension Decodable {

    static func byYielding(to yield: @escaping YieldingDecoderClosure) throws -> Self {
        try Self.init(from: YieldingDecoder(yield))
    }
}

public protocol SingleValueDecodingContainerDefaulting: Decodable {
    static var singleValueDecodingContainerDefault: Self { get }
}

class YieldingDecoder: Decoder {

    /// Developed in collaboration with https://github.com/ollieatkinson

    let yield: YieldingDecoderClosure

    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] { [:] }
    
    init(_ yield: @escaping YieldingDecoderClosure) { self.yield = yield }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        .init(KeyedContainer.yield(self))
    }

    enum KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {

        case yield(YieldingDecoder)

        var codingPath: [CodingKey] { [] }

        var allKeys: [Key] { [] }

        func contains(_ key: Key) -> Bool {
            true
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            false
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            guard case let .yield(decoder) = self else { fatalError("impossible") }
            defer { decoder.codingPath.removeLast() }
            decoder.codingPath.append(key)
            let ªt = try decoder.yield(T.self, decoder.codingPath, { try T.init(from: decoder) })
            guard let t = ªt as? T else {
                throw "YieldingDecoderClosure did not return a \(T.self), but a \(Swift.type(of: ªt))".error()
            }
            return t
        }
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        UnkeyedContainer.default
    }

    enum UnkeyedContainer: UnkeyedDecodingContainer {
        case `default`
        var codingPath: [CodingKey] { [] }
        var count: Int? { 0 }
        var isAtEnd: Bool { true }
        var currentIndex: Int { -1 }
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer.default
    }

    enum SingleValueContainer: SingleValueDecodingContainer {

        case `default`

        var codingPath: [CodingKey] { [] }

        func decodeNil() -> Bool {
            false
        }

        func decode<T>(_ type: T.Type) throws -> T where T : Decodable, T : AdditiveArithmetic { .zero }
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable, T : ExpressibleByNilLiteral { nil }
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable, T : ExpressibleByBooleanLiteral { false }
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable, T : ExpressibleByStringLiteral { "" }

        func decode<T>(_ type: T.Type) throws -> T where T : SingleValueDecodingContainerDefaulting {
            T.singleValueDecodingContainerDefault
        }

        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            throw "Cannot initialize a default \(T.self) because it is not a SingleValueDecodingContainerDefaulting".error()
        }
    }
}

extension YieldingDecoder.KeyedContainer {
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw "❓".error()
    }
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw "❓".error()
    }
    func superDecoder() throws -> Decoder {
        throw "❓".error()
    }
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw "❓".error()
    }
}

extension YieldingDecoder.UnkeyedContainer {
    mutating func decodeNil() throws -> Bool {
        throw "❓".error()
    }
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        throw "❓".error()
    }
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw "❓".error()
    }
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw "❓".error()
    }
    mutating func superDecoder() throws -> Decoder {
        throw "❓".error()
    }
}
