public struct EitherType<A, B> {
    public private(set) var value: Value
}

extension EitherType {
    public enum Value { case a(A), b(B) }
}

extension EitherType {
    public init(_ a: A) { value = .a(a) }
    public init(_ b: B) { value = .b(b) }
}

extension EitherType {
    public var a: A? { if case let .a(o) = value { return o} else { return nil } }
    public var b: B? { if case let .b(o) = value { return o} else { return nil } }
}

extension EitherType.Value: Equatable where A: Equatable, B: Equatable {}

extension EitherType: Equatable where A: Equatable, B: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

extension EitherType.Value: Hashable where A: Hashable, B: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .a(o): hasher.combine(o)
        case let .b(o): hasher.combine(o)
        }
    }
}

extension EitherType: Hashable where A: Hashable, B: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension EitherType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let .a(o): return String(describing: o)
        case let .b(o): return String(describing: o)
        }
    }
}

