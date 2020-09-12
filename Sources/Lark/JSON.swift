public struct JSON {
    
    public typealias Path = [IntOrString]
    
    public private(set) var value: Any
    
    public init(_ value: Any) { self.value = value }
    
    @inlinable public subscript(path: IntOrString...) -> JSON? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    public subscript(path: Path) -> JSON? {
        get {
            if path.isEmpty { return self }
            fatalError()
        }
        set {
            guard !path.isEmpty else {
                value = newValue?.value ?? JSONNull
                return
            }
        }
    }
}

public let JSONNull: [String: Any] = [:]

public protocol JSONValue {}
extension Bool: JSONValue {}
extension Int: JSONValue {}
extension Double: JSONValue {}
extension String: JSONValue {}

public protocol JSONCollection: Collection {}
extension Array: JSONCollection {}
extension Dictionary: JSONCollection where Key == String {}

public protocol SelflessEquatable {
    func selflessEqual(to other: Any) -> Bool
}

extension SelflessEquatable where Self: Equatable {
    public func selflessEqual(to other: Any) -> Bool {
        self == (other as? Self)
    }
}

extension JSON: Equatable {
    
    public static func == (l: JSON, r: JSON) -> Bool {
        if let l = l.value as? [Any], let r = r.value as? [Any] {
            return l == r
        }
        return false
    }
}

extension Array where Element == Any {
    
    public static func == (l: Array, r: Array) -> Bool {
        guard l.count == r.count else { return false }
        return zip(l, r).allSatisfy{ l, r in
            if let l = l as? SelflessEquatable { return l.selflessEqual(to: r) }
            if let r = r as? SelflessEquatable { return r.selflessEqual(to: l) }
            return false
        }
    }
}

extension Dictionary where Self == [String: Any] {
    
    public static func == (l: Dictionary, r: Dictionary) -> Bool {
        guard l.count == r.count else { return false }
        return zip(l, r).allSatisfy{ l, r in
            JSON(l) == JSON(r)
        }
    }
}

extension JSON: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self.init([:]) }
}

extension JSON: ExpressibleByBooleanLiteral {
    @inlinable public init(booleanLiteral value: BooleanLiteralType) { self.init(value) }
}

extension JSON: ExpressibleByIntegerLiteral {
    @inlinable public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension JSON: ExpressibleByStringLiteral {
    @inlinable public init(stringLiteral value: String) { self.init(value) }
}

extension JSON: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Any...) { self.init(elements) }
}

extension JSON: ExpressibleByDictionaryLiteral {
    @inlinable public init(dictionaryLiteral elements: (String, Any)...) { self.init(Dictionary(elements){ $1 }) }
}
