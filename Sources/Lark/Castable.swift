public protocol Castable {
    init<A>(_ a: A, _ function: String, _ file: String, _ line: Int) throws
    func cast<A>(to: A.Type, _ function: String, _ file: String, _ line: Int) throws -> A
}

extension Castable {
    
    public init<A>(
        _ a: A,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws {
        throw "\(Self.self).init as \(Castable.self) not implemented".error()
    }
    
    public func cast<A>(
        to: A.Type = A.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        guard let a = self as? A else {
            throw "\(self) is not \(A.self)".error()
        }
        return a
    }
    
    @inlinable public func `as`<A>(
        _: A.Type = A.self,
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ) throws -> A {
        try cast(to: A.self, function, file, line)
    }
}

