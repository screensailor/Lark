import Peek

public enum Sink {}

extension Sink {
    public final class Var<A> {
        public var bag: Bag = []
        @Published public fileprivate(set) var value: A
        public init(_ value: A){ self.value = value }
    }
}

extension Sink {
    public final class Optional<A> {
        public var bag: Bag = []
        @Published public fileprivate(set) var value: A?
        public init(_ value: A){ self.value = value }
        public init(){}
    }
}

extension Sink {
    public final class Result<A> {
        public var bag: Bag = []
        @Published public fileprivate(set) var result: Swift.Result<A, Error>
        @inlinable public var value: A? { result.value }
        @inlinable public var error: Error? { result.error }
        public init(_ result: Swift.Result<A, Error>){ self.result = result }
        public init(_ result: A){ self.result = .success(result) }
    }
}

extension Result {
    @inlinable public var value: Success? { if case .success(let o) = self { return o } else { return nil } }
    @inlinable public var error: Failure? { if case .failure(let o) = self { return o } else { return nil } }
}

extension Publisher {
    
    @inlinable
    public static func ...= <A>(lhs: Sink.Var<A>, rhs: Self) where Output == A {
        rhs.sink(lhs)
    }

    public func sink<A>(_ sink: Sink.Var<A>) where Output == A {
        self.sink { _ in
        } receiveValue: { output in
            sink.value = output
        }.in(&sink.bag)
    }

    @inlinable
    public static func ...= (lhs: Sink.Optional<Output>, rhs: Self) {
        rhs.sink(lhs)
    }

    public func sink(_ sink: Sink.Optional<Output>) {
        self.sink { completion in
            if case .failure = completion {
                sink.value = nil
            }
        } receiveValue: { output in
            sink.value = output
        }.in(&sink.bag)
    }

    @inlinable
    public static func ...= <A>(lhs: Sink.Optional<A>, rhs: Self) where Output == A? {
        rhs.sink(lhs)
    }

    public func sink<A>(_ sink: Sink.Optional<A>) where Output == A? {
        self.sink { completion in
            if case .failure = completion {
                sink.value = nil
            }
        } receiveValue: { output in
            sink.value = output
        }.in(&sink.bag)
    }

    @inlinable
    public static func ...= (lhs: Sink.Result<Output>, rhs: Self) {
        rhs.sink(lhs)
    }

    public func sink(_ sink: Sink.Result<Output>) {
        self.sink { completion in
            if case .failure(let o) = completion {
                sink.result = .failure(o)
            }
        } receiveValue: { output in
            sink.result = .success(output)
        }.in(&sink.bag)
    }
}
