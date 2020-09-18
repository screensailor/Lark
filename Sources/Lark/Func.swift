public protocol Func: CustomStringConvertible {
    init()
    func callAsFunction<X>(_ x: [X]) throws -> X where X: Castable // TODO: capture code location for errors
}

public struct Identity: Func {
    
    public let description = "Expects one element, which is returned unchanged"
    
    public init() {}

    public func callAsFunction<X>(_ x: [X]) throws -> X where X : Castable {
        guard x.count == 1 else { throw "\(Identity.self) x.count: \(x.count)".error() }
        return x[0]
    }
}

public struct Sum: Func {
    
    public let description = "Expects an array of numbers and returns their sum"

    public init() {}

    public func callAsFunction<X>(_ x: [X]) throws -> X where X: Castable {
        let o = try x.reduce(0){ a, e in try a + e.as(Double.self) }
        return try X(o)
    }
}

public struct Product: Func {
    
    public let description = "Expects an array of numbers and returns their product"

    public init() {}
    
    public func callAsFunction<X>(_ x: [X]) throws -> X where X: Castable {
        let o = try x.reduce(1){ a, e in try a * e.as(Double.self) }
        return try X(o)
    }
}
