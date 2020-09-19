public protocol BrainFunction: CustomStringConvertible {
    func callAsFunction<X>(x: [X]) -> Future<X, Never> where X: BrainWave
}

public protocol SyncBrainFunction: BrainFunction {
    func ƒ<X>(x: [X]) throws -> X where X: BrainWave
}

extension SyncBrainFunction {
    public func callAsFunction<X>(x: [X]) -> Future<X, Never> where X : BrainWave {
        Future{ promise in
            do {
                try promise(.success(ƒ(x: x)))
            } catch let error as BrainError {
                promise(.success(X(error)))
            } catch {
                promise(.success(X("\(error)".error())))
            }
        }
    }
}

public protocol AsyncBrainFunction: BrainFunction {
    func ƒ<X>(x: [X], result: @escaping (Result<X, BrainError>) throws -> ()) where X: BrainWave
}

extension AsyncBrainFunction {
    public func callAsFunction<X>(x: [X]) -> Future<X, Never> where X : BrainWave {
        Future{ promise in
            ƒ(x: x){ result in
                do {
                    try promise(.success(result.get()))
                } catch let error as BrainError {
                    promise(.success(X(error)))
                } catch {
                    promise(.success(X("\(error)".error())))
                }
            }
        }
    }
}

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
