public protocol ExpressibleByErrorValue {
    var isError: Bool { get }
    init(_ error: Peek.Error)
    func throwIfError() throws -> Self
}

extension ExpressibleByErrorValue {
    
    @inlinable public func throwIfError() throws -> Self {
        if isError { throw String.Error(self) } else { return self }
    }
}

