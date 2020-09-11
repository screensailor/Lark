infix operator ...= : BitwiseShiftPrecedence

extension Publisher {
    
    @inlinable public func filter<A>(_: A.Type = A.self) -> Publishers.CompactMap<Self, A> {
        compactMap{ $0 as? A }
    }
    
    @inlinable public func filter<Root, Property>(_ k: KeyPath<Root, Property>) -> Publishers.CompactMap<Self, Property> {
        compactMap{ ($0 as? Root)?[keyPath: k] }
    }

    public func sink(_ sink: Sink.Result<Output, Failure>) -> AnyCancellable {
        self.sink { completion in
            switch completion {
            case .finished: break
            case .failure(let o): sink.result = .failure(o)
            }
        } receiveValue: { output in
            sink.result = .success(output)
        }
    }
    
    @inlinable public static func ...= (lhs: Sink.Result<Output, Failure>, rhs: Self) -> AnyCancellable {
        rhs.sink(lhs)
    }
}

extension Publishers.Print {
    
    @inlinable public func `in`(_ bag: inout Bag) {
        sink(receiveCompletion: {_ in}, receiveValue: {_ in}).store(in: &bag)
    }
}

public typealias Bag = Set<AnyCancellable>

extension Cancellable {

    @inlinable public func `in`(_ bag: inout Bag) {
        store(in: &bag)
    }
    
    @inlinable public static func / (lhs: Self, rhs: inout Bag) {
        lhs.store(in: &rhs)
    }
}

// MARK: Sink

public enum Sink {}
    
extension Sink {
    public final class Result<Success, Failure: Error> {
        public fileprivate(set) var result: Swift.Result<Success, Failure>
        public init(_ result: Swift.Result<Success, Failure>){ self.result = result }
    }
}

extension Sink.Result {
    public convenience init(_ value: Success){ self.init(.success(value)) }
    public convenience init(_ failure: Failure){ self.init(.failure(failure)) }
}

extension Sink.Result where Failure == Never {
    public convenience init(_ value: Success){ self.init(.success(value)) }
}

extension Sink.Result {
    @inlinable public var value: Success? { try? result.get() }
}
