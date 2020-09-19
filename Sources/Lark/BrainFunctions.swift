public struct Identity: SyncBrainFunction {
    
    public let description = "Expects one element, which is returned unchanged"
    
    public init() {}
    
    public func ƒ<X>(x: [X]) throws -> X where X: BrainWave {
        guard x.count == 1 else { throw "\(Identity.self) x.count: \(x.count)".error() }
        return x[0]
    }
}

public struct Sum: SyncBrainFunction {

    public let description = "Expects an array of numbers and returns their sum"

    public init() {}

    public func ƒ<X>(x: [X]) throws -> X where X: BrainWave {
        let o = try x.reduce(0){ a, e in try a + e.as(Double.self) }
        return try X(o)
    }
}

public struct Product: SyncBrainFunction {

    public let description = "Expects an array of numbers and returns their product"

    public init() {}

    public func ƒ<X>(x: [X]) throws -> X where X: BrainWave {
        let o = try x.reduce(1){ a, e in try a * e.as(Double.self) }
        return try X(o)
    }
}
