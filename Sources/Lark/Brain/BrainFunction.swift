public protocol BrainFunction: CustomStringConvertible {
    func callAsFunction<X>(_ x: [X]) -> Future<X, Never> where X: BrainWave
}

public protocol SyncBrainFunction: BrainFunction {
    func ƒ<X>(x: [X]) throws -> X? where X: BrainWave
}

public protocol AsyncBrainFunction: BrainFunction {
    func ƒ<X>(x: [X], result: @escaping (() throws -> X) -> ()) where X: BrainWave
}

extension SyncBrainFunction {
    
    public func callAsFunction<X>(_ x: [X]) -> Future<X, Never> where X : BrainWave {
        return Future{ promise in
            guard let y = X.catch({ try ƒ(x: x) }) else { return }
            promise(.success(y))
        }
    }
}

extension AsyncBrainFunction {
    
    public func callAsFunction<X>(_ x: [X]) -> Future<X, Never> where X : BrainWave {
        Future{ promise in
            ƒ(x: x){ ƒ in
                let y = X.catch(ƒ)
                promise(.success(y))
            }
        }
    }
}
