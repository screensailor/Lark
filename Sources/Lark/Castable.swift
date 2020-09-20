public protocol Castable {
    static func from<A>(_ a: A, _ function: String, _ file: String, _ line: Int) throws -> Self
    func cast<A>(to: A.Type, _ function: String, _ file: String, _ line: Int) throws -> A
}

extension Castable {
    
    @inlinable public init<A>(
        _ a: A,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws {
        self = try Self.from(a, function, file, line)
    }
    
    @inlinable public func `as`<A>(
        _: A.Type = A.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        try cast(to: A.self, function, file, line)
    }
    
    @inlinable public func cast<A>(
        `default` o: A,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) -> A {
        (try? cast(to: A.self, function, file, line)) ?? o
    }
}

