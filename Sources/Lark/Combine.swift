extension Publisher {
    
    @inlinable public func filter<A>(_: A.Type = A.self) -> Publishers.CompactMap<Self, A> {
        compactMap{ $0 as? A }
    }
    
    @inlinable public func filter<Root, Property>(_ k: KeyPath<Root, Property>) -> Publishers.CompactMap<Self, Property> {
        compactMap{ ($0 as? Root)?[keyPath: k] }
    }

    public func sink(_ sink: Sink.Result<Output, Failure>) -> AnyCancellable {
        self.sink { completion in
            if case .failure(let o) = completion {
                sink.result = .failure(o)
            }
        } receiveValue: { output in
            sink.result = .success(output)
        }
    }

    public func sink(_ sink: Sink.Var<Output>) -> AnyCancellable {
        self.sink { completion in
            if case .failure = completion {
                sink.value = nil
            }
        } receiveValue: { output in
            sink.value = output
        }
    }

    public func sink<A>(_ sink: Sink.Var<A>) -> AnyCancellable where Output == A? {
        self.sink { completion in
            if case .failure = completion {
                sink.value = nil
            }
        } receiveValue: { output in
            sink.value = output
        }
    }

    @inlinable public static func ...= (lhs: Sink.Result<Output, Failure>, rhs: Self) -> AnyCancellable {
        rhs.sink(lhs)
    }

    @inlinable public static func ...= (lhs: Sink.Var<Output>, rhs: Self) -> AnyCancellable {
        rhs.sink(lhs)
    }

    @inlinable public static func ...= <A>(lhs: Sink.Var<A>, rhs: Self) -> AnyCancellable where Output == A? {
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

public enum Sink {}

extension Sink {
    public final class Var<Value> {
        public fileprivate(set) var value: Value?
        public init(_ value: Value){ self.value = value }
        public init(){}
    }
}

extension Sink {
    public final class Result<Success, Failure: Error> {
        public fileprivate(set) var result: Swift.Result<Success, Failure>
        public init(_ result: Swift.Result<Success, Failure>){ self.result = result }
    }
}

extension Result {
    @inlinable public var value: Success? { if case .success(let o) = self { return o } else { return nil } }
    @inlinable public var error: Failure? { if case .failure(let o) = self { return o } else { return nil } }
}
