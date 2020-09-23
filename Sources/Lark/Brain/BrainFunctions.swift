// TODO: Declared typed parameters and the abstracted argument casting

public struct Identity: SyncBrainFunction {
    
    public let description = "Expects one element, which is returned unchanged"
    
    public init() {}
    
    public func ƒ<X>(x: [X]) throws -> X? where X: BrainWave {
        guard x.count == 1 else { throw "\(Identity.self) x.count: \(x.count)".error() }
        return x[0]
    }
}

public struct Sum: SyncBrainFunction {

    public let description = "Expects an array of numbers and returns their sum"

    public init() {}

    public func ƒ<X>(x: [X]) throws -> X? where X: BrainWave {
        let o = try x.reduce(0){ a, e in try a + e.as(Double.self) }
        return try X(o)
    }
}

public struct Product: SyncBrainFunction {

    public let description = "Expects an array of numbers and returns their product"

    public init() {}

    public func ƒ<X>(x: [X]) throws -> X? where X: BrainWave {
        let o = try x.reduce(1){ a, e in try a * e.as(Double.self) }
        return try X(o)
    }
}

public struct After: AsyncBrainFunction {
    
    public let description = "Returns x[1] after x[0] seconds"
    
    public init() {}
    
    public func ƒ<X>(x: [X], result: @escaping (() throws -> X) -> ()) where X: BrainWave {
        do {
            guard x.count == 2 else { throw "\(After.self) x.count: \(x.count)".error() }
            try DispatchQueue.main.asyncAfter(deadline: .now() + x[0].as(TimeInterval.self)) {
                result{ x[1] }
            }
        } catch {
            result{ throw error }
        }
    }
}
