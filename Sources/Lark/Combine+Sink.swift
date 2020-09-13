public enum Sink {}

extension Sink {
    public final class Var<Value> {
        public var bag: Bag = []
        @Published public fileprivate(set) var value: Value?
        public init(_ value: Value){ self.value = value }
        public init(){}
    }
}

extension Sink {
    public final class Result<Success, Failure: Error> {
        public var bag: Bag = []
        @Published public fileprivate(set) var result: Swift.Result<Success, Failure>
        public init(_ result: Swift.Result<Success, Failure>){ self.result = result }
    }
}

extension Result {
    @inlinable public var value: Success? { if case .success(let o) = self { return o } else { return nil } }
    @inlinable public var error: Failure? { if case .failure(let o) = self { return o } else { return nil } }
}

extension Publisher {
    
    @discardableResult
    public func sink(_ sink: Sink.Result<Output, Failure>) -> Sink.Result<Output, Failure> {
        self.sink { completion in
            if case .failure(let o) = completion {
                sink.result = .failure(o)
            }
        } receiveValue: { output in
            sink.result = .success(output)
        }.in(&sink.bag)
        return sink
    }

    @discardableResult
    public func sink(_ sink: Sink.Var<Output>) -> Sink.Var<Output> {
        self.sink { completion in
            if case .failure = completion {
                sink.value = nil
            }
        } receiveValue: { output in
            sink.value = output
        }.in(&sink.bag)
        return sink
    }

    @discardableResult
    public func sink<A>(_ sink: Sink.Var<A>) -> Sink.Var<A> where Output == A? {
        self.sink { completion in
            if case .failure = completion {
                sink.value = nil
            }
        } receiveValue: { output in
            sink.value = output
        }.in(&sink.bag)
        return sink
    }

    @inlinable
    @discardableResult
    public static func ...= (lhs: Sink.Result<Output, Failure>, rhs: Self) -> Sink.Result<Output, Failure> {
        rhs.sink(lhs)
    }

    @inlinable
    @discardableResult
    public static func ...= (lhs: Sink.Var<Output>, rhs: Self) -> Sink.Var<Output> {
        rhs.sink(lhs)
    }

    @inlinable
    @discardableResult
    public static func ...= <A>(lhs: Sink.Var<A>, rhs: Self) -> Sink.Var<A> where Output == A? {
        rhs.sink(lhs)
    }
}
