public extension Decodable {
    
    static func defaultDecodingValue() throws -> Self {
        try Self(from: DefaultingDecoder())
    }
}

public protocol SingleValueDecodingContainerDefaulting: Decodable {
    static var singleValueDecodingContainerDefault: Self { get }
}

struct DefaultingDecoder: Decoder {
    
    var codingPath: [CodingKey] { [] }
    
    var userInfo: [CodingUserInfoKey : Any] { [:] }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        .init(KeyedContainer.default)
    }
    
    enum KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        
        case `default`
        
        var codingPath: [CodingKey] { [] }
        
        var allKeys: [Key] { [] }
        
        func contains(_ key: Key) -> Bool {
            true
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            false
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            print("✅", key.stringValue, T.self)
            return try T(from: DefaultingDecoder())
        }
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        UnkeyedContainer.default
    }
    
    enum UnkeyedContainer: UnkeyedDecodingContainer {
        case `default`
        var codingPath: [CodingKey] { [] }
        var count: Int? { 0 }
        var isAtEnd: Bool { true }
        var currentIndex: Int { -1 }
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
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

extension DefaultingDecoder.KeyedContainer {
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

extension DefaultingDecoder.UnkeyedContainer {
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
