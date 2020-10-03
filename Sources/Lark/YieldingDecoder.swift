/// Developed in collaboration with https://github.com/ollieatkinson

/// TODO: yield optionals❗️
/// TODO: YieldingDecoderIterator

public typealias YieldingDecoderClosure = (
    _ type: Any.Type,
    _ path: [CodingKey],
    _ defaultValue: () throws -> Any
) throws -> Any

public extension Decodable {

    static func byYielding(to yield: @escaping YieldingDecoderClosure) throws -> Self {
        try Self.init(from: YieldingDecoder<Self>(yield))
    }
}

class YieldingDecoder<A>: Decoder {

    let yield: YieldingDecoderClosure

    var codingPath: [CodingKey] = []
    var codingPathTypes: Set<AnyType> = []
    var userInfo: [CodingUserInfoKey : Any] { [:] }
    
    lazy var map: [String: PartialKeyPath<A>] = Dictionary(Reflection.allNamedKeyPaths(for: A.self)){ $1 }

    init(_ yield: @escaping YieldingDecoderClosure) { self.yield = yield }
    
    private init<B>(_ parent: YieldingDecoder<B>) {
        self.yield = parent.yield
        self.codingPath = parent.codingPath
        self.codingPathTypes = parent.codingPathTypes
    }

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
            switch self {
            case .yield(let o):
                guard let path = o.map[key.stringValue] else { return true }
                
                print("❗️", key.stringValue, path)
                
                return true
            }
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            switch self {
            case .yield(let o):
                defer {
                    o.codingPath.removeLast()
                    o.codingPathTypes.remove(T.self)
                }
                o.codingPath.append(key)
                guard !o.codingPathTypes.contains(T.self) else {
                    throw "Encountered recursion with type \(T.self) at \(o.codingPath.map(\.stringValue))".error()
                }
                o.codingPathTypes.insert(T.self)
                let ªt = try o.yield(T.self, o.codingPath, { try T.init(from: YieldingDecoder<T>(o)) })
                guard let t = ªt as? T else {
                    throw "YieldingDecoderClosure did not return a \(T.self), but a \(Swift.type(of: ªt))".error()
                }
                return t
            }
        }
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        DefaultingDecoder.UnkeyedContainer.default
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        DefaultingDecoder.SingleValueContainer.default
    }
}

extension YieldingDecoder.KeyedContainer {
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw "Not implemented".error()
    }
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw "Not implemented".error()
    }
    func superDecoder() throws -> Decoder {
        throw "Not implemented".error()
    }
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw "Not implemented".error()
    }
}
