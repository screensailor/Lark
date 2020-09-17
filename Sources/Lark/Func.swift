public protocol Func {
    init()
    func ƒ<X>(_ x: [X]) throws -> X where X: Castable
}

public struct Identity: Func {
    
    public init() {}

    // TODO: capture code location for errors
    public func ƒ<X>(_ x: [X]) throws -> X where X : Castable {
        guard x.count == 1 else { throw "\(Identity.self) x.count: \(x.count)".error() }
        return x[0]
    }
}

