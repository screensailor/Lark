import Peek

@dynamicMemberLookup
public indirect enum Tree<Key, Leaf>
where Key: Hashable, Leaf: Castable
{
    case leaf(Leaf)
    case array([Tree])
    case dictionary([Key: Tree])
}

extension Tree where Key: ExpressibleByStringLiteral {
    public subscript(dynamicMember key: Key) -> Self? {
        self[[Tree.Index(key)]] // TODO: set
    }
}
    
extension Tree {
    
    public static var empty: Tree { .dictionary([:]) }
    
    public init() { self = .empty }
    public init(_ o: Self) { self = o }
    public init(_ o: Leaf) { self = .leaf(o) }
}

extension Tree: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self.init() }
}

extension Tree: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Tree...) { self = .array(elements) }
}

extension Tree: ExpressibleByDictionaryLiteral {
    @inlinable public init(dictionaryLiteral elements: (Key, Tree)...) { self = .dictionary(.init(uniqueKeysWithValues: elements)) }
}

extension Tree { // TODO: Encoder and Decoder
    
    public func cast(
        to: Any.Type = Any.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> Any {
        switch self {
        case let .leaf(o): return try o.cast(to: Any.self, function, file, line)
        case let .array(o): return try o.map{ try $0.cast(to: Any.self, function, file, line) }
        case let .dictionary(o): return try o.mapValues{ try $0.cast(to: Any.self, function, file, line) }
        }
    }
    
    public func cast<A>(
        to: A.Type = A.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        switch self {
        case let .leaf(o): return try o.cast(to: A.self, function, file, line)
        case .array, .dictionary: throw "\(self) is not \(A.self)".error(function, file, line)
        }
    }

    public func cast<A>(
        to: [A].Type = [A].self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> [A] {
        switch self {
        case let .array(o): return try o.map{ try $0.cast(to: A.self, function, file, line) }
        case .leaf, .dictionary: throw "\(self) is not \([A].self)".error(function, file, line)
        }
    }
    
    public func cast<A>(
        to: [Key: A].Type = [Key: A].self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> [Key: A] {
        switch self {
        case let .dictionary(o): return try o.mapValues{ try $0.cast(to: A.self, function, file, line) }
        case .leaf, .array: throw "\(self) is not \([Key: A].self)".error(function, file, line)
        }
    }
}

extension Tree {
    
    @inlinable public func `as`(
        _: Any.Type = Any.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> Any {
        try cast(function, file, line)
    }
    
    @inlinable public func `as`<A>(
        _: A.Type = A.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        try cast(function, file, line)
    }

    @inlinable public func `as`<A>(
        _: [A].Type = [A].self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> [A] {
        try cast(function, file, line)
    }
    
    @inlinable public func `as`<A>(
        _: [Key: A].Type = [Key: A].self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> [Key: A] {
        try cast(function, file, line)
    }
}

extension Tree {
    
    public typealias Index = EitherType<Int, Key>
    public typealias Path = [Index]

    @inlinable public subscript(path: Index..., default o: Self) -> Self {
        self[path] ?? o
    }

    @inlinable public subscript(path: Index...) -> Self? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    @inlinable public subscript<Path>(path: Path, default o: Self) -> Self
    where Path: Collection, Path.Element == Index
    {
        self[path] ?? o
    }
    
    public subscript<Path>(path: Path) -> Self?
    where Path: Collection, Path.Element == Index
    {
        get {
            guard let first = path.first else { return self }
            switch self
            {
            case .leaf:
                return self
                
            case let .array(o):
                guard let i = first[Int.self], o.indices.contains(i) else {
                    return nil
                }
                return o[i][path.dropFirst()]
                
            case let .dictionary(o):
                guard let key = first[Key.self] else {
                    return nil
                }
                return o[key]?[path.dropFirst()]
            }
        }
        set {
            let new = newValue ?? .empty
            guard let first = path.first else {
                self = new
                return
            }
            switch self
            {
            case .leaf:
                switch first.value
                {
                case let .a(i):
                    var o = Array(repeating: Self.empty, count: i)
                    o.append(new)
                    self = .array(o)
                    
                case let .b(key):
                    self = .dictionary([key: new])
                }
                
            case var .array(o):
                switch first.value
                {
                case let .a(i):
                    o.append(
                        contentsOf: Array(repeating: Self.empty, count: max(0, 1 + i - o.count))
                    )
                    o[i] = new
                    self = .array(o)
                    
                case let .b(key):
                    self = .dictionary([key: new])
                }

            case var .dictionary(o):
                switch first.value
                {
                case let .a(i):
                    var o = Array(repeating: Self.empty, count: i)
                    o.append(new)
                    self = .array(o)

                case let .b(key):
                    o[key] = new
                    self = .dictionary(o)
                }
            }
        }
    }
}

extension Tree: Equatable where Leaf: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.leaf(l), .leaf(r)): return l == r
        case let (.array(l), .array(r)): return l == r
        case let (.dictionary(l), .dictionary(r)): return l == r
        default: return false
        }
    }
}
