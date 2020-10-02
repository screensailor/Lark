public struct AnyType: Hashable, CustomStringConvertible {

    public let type: Any.Type
    public let description: String

    public init<T>(_ type: T.Type) {
        self.type = type
        self.description = String(reflecting: T.self)
    }
}

extension AnyType { // Hashable

    public static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}

extension AnyType { // Decodable

    public init<T: Decodable>(_ type: T.Type) { 
        self.type = type
        self.description = String(reflecting: T.self)
        AnyType.queue.sync {
            if !AnyType.memoized.keys.contains(self) {
                AnyType.memoized[self] = { json, decoder in try decoder.decode(T.self, from: json) }
            }
        }
    }

    public func decode(json: Data, using decoder: JSONDecoder = .init()) throws -> Any {
        guard let decode = AnyType.queue.sync(execute: { AnyType.memoized[self] }) else {
            throw "'\(description)' is not Decodable".error()
        }
        return try decode(json, decoder)
    }
    
    private static let queue = DispatchQueue(label: "net.screensailor.AnyType.queue")
    private static var memoized: [AnyType : (Data, JSONDecoder) throws -> Any] = [:]
}

extension Dictionary where Key == AnyType {
    
    @inlinable public subscript<T>(_ type: T.Type) -> Value? {
        get { return self[AnyType(T.self)] }
        set { self[AnyType(T.self)] = newValue }
    }
}

extension Set where Element == AnyType {
    
    @inlinable public func contains<T>(_ type: T.Type) -> Bool {
        contains(AnyType(T.self))
    }
    
    @inlinable public mutating func insert<T>(_ type: T.Type) -> (inserted: Bool, memberAfterInsert: AnyType) {
        insert(AnyType(T.self))
    }
    
    @inlinable public mutating func remove<T>(_ type: T.Type) -> AnyType? {
        remove(AnyType(T.self))
    }
}
