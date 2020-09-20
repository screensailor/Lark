public protocol BrainFunction: CustomStringConvertible {
    func callAsFunction<X>(x: [X]) -> Future<X, Never> where X: BrainWave
}

public protocol SyncBrainFunction: BrainFunction {
    func ƒ<X>(x: [X]) throws -> X where X: BrainWave
}

public protocol AsyncBrainFunction: BrainFunction {
    func ƒ<X>(x: [X], result: @escaping (() throws -> X) -> ()) where X: BrainWave
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

extension AsyncBrainFunction {
    
    public func callAsFunction<X>(x: [X]) -> Future<X, Never> where X : BrainWave {
        Future{ promise in
            ƒ(x: x){ result in
                do {
                    try promise(.success(result()))
                } catch let error as BrainError {
                    promise(.success(X(error)))
                } catch {
                    promise(.success(X("\(error)".error())))
                }
            }
        }
    }
}
