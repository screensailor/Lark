public enum Sink {}

extension Sink {
    
    public final class Var<A>: ReferenceWriteSubscriptable {
        @inlinable public static var subscriptRoot: ReferenceWritableKeyPath<Sink.Var<A>, A> { \.__o }
        @usableFromInline @Published var __o: A
        public var bag: Bag = []
        public init(_ value: A){ self.__o = value }
    }
}

extension Sink {
    
    public final class Result<A>: ReferenceWriteSubscriptable {
        @inlinable public static var subscriptRoot: ReferenceWritableKeyPath<Sink.Result<A>, Swift.Result<A, Error>> { \.__o }
        @usableFromInline @Published var __o: Swift.Result<A, Error>
        public var bag: Bag = []
        public init(_ result: Swift.Result<A, Error>){ self.__o = result }
        public init(_ result: A){ self.__o = .success(result) }
    }
}

extension Publisher {
    
    @inlinable
    public static func ...= <A>(lhs: Sink.Var<A>, rhs: Self) where Output == A {
        rhs.sink(lhs)
    }

    public func sink<A>(_ sink: Sink.Var<A>) where Output == A {
        self.sink { _ in
        } receiveValue: { output in
            sink.__o = output
        }.in(&sink.bag)
    }

    @inlinable
    public static func ...= (lhs: Sink.Result<Output>, rhs: Self) {
        rhs.sink(lhs)
    }

    public func sink(_ sink: Sink.Result<Output>) {
        self.sink { completion in
            if case .failure(let o) = completion {
                sink.__o = .failure(o)
            }
        } receiveValue: { output in
            sink.__o = .success(output)
        }.in(&sink.bag)
    }
}
