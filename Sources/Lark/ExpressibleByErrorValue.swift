public protocol ExpressibleByErrorValue {
    var isError: Bool { get }
    init(_ error: BrainError)
    func throwIfError() throws -> Self
}

extension ExpressibleByErrorValue {
    
    @inlinable public func throwIfError() throws -> Self {
        if isError { throw BrainError(self) } else { return self }
    }
}

