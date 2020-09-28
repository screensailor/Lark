extension Encodable {
    
    public func encode(_ yield: @escaping ([CodingKey]) throws -> ()) throws {
        try self.encode(to: YieldingEncoder(yield))
    }
}

public final class YieldingEncoder: Encoder {
    
    public fileprivate(set) var codingPath: [CodingKey] = []

    fileprivate let yield: ([CodingKey]) throws -> ()
    
    fileprivate init(_ yield: @escaping ([CodingKey]) throws -> ()) {
        self.yield = yield
    }

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        .init(KeyedEncoding(for: self))
    }
    
    class KeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {
        
        var codingPath: [CodingKey] { encoder?.codingPath ?? [] }
        
        private weak var encoder: YieldingEncoder?
        
        init(for encoder: YieldingEncoder) {
            self.encoder = encoder
        }

        func encodeNil(forKey key: Key) throws {}

        func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
            guard let encoder = encoder else { return }
            defer { encoder.codingPath.removeLast() }
            encoder.codingPath.append(key)
            try encoder.yield(encoder.codingPath)
            try value.encode(to: encoder)
        }
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        UnkeyedEncoding(for: self)
    }

    class UnkeyedEncoding: UnkeyedEncodingContainer {
        
        var codingPath: [CodingKey] { encoder?.codingPath ?? [] }
        
        var count: Int = -1
        
        private weak var encoder: YieldingEncoder?

        init(for encoder: YieldingEncoder) {
            self.encoder = encoder
        }

        func encodeNil() throws {}
        
        func encode<T>(_ value: T) throws where T : Encodable {
            count += 1
            guard let encoder = encoder else { return }
            defer { encoder.codingPath.removeLast() }
            encoder.codingPath.append(IntOrString(count))
            try encoder.yield(encoder.codingPath)
            try value.encode(to: encoder)
        }
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        SingleValueEncoding()
    }

    class SingleValueEncoding: SingleValueEncodingContainer {
        let codingPath: [CodingKey] = []
        init() {}
        func encodeNil() throws {}
        func encode<T>(_ value: T) throws where T: Encodable {}
    }
}

extension YieldingEncoder {
    
    public var userInfo: [CodingUserInfoKey : Any] { [:] }
}

extension YieldingEncoder.UnkeyedEncoding {

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
}

extension YieldingEncoder.KeyedEncoding {

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
}
