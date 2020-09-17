import Lark
import Hope

infix operator ...= : BitwiseShiftPrecedence

class Sink™: Hopes {
    
    @Published private var json: JSON = nil
    
    func test_1() {
        
        let o = Sink.Var<JSON>(nil)
        
        let x: JSON.Path = ["a", "b", 3]
        
        o ...= $json[x]
        
        hope(o[]) == nil
        
        json[x] = "c"
        
        hope(o[]) == "c"
    }
    
    func test_2() throws {
        
        let o = Sink.Result(0)

        let x = $json["a", "b", 3].when(Int.self)
        let y = $json["somewhere", "else"].when(Int.self)
        
        o ...= x.combineLatest(y).map(+)

        try hope(o[].get()) == 0
        
        json["a", "b", 3] = 4
        
        try hope(o[].get()) == 0

        json["somewhere", "else"] = 12

        try hope(o[].get()) == 16
    }
}

public enum Sink {}

extension Sink {
    
    public final class Var<A>: ReferenceWriteSubscriptable {
        @inlinable public static var subscriptRoot: ReferenceWritableKeyPath<Sink.Var<A>, A> { \.__o }
        @usableFromInline @Published var __o: A
        var bag: Bag = []
        public init(_ value: A){ self.__o = value }
    }
}

extension Sink {
    
    public final class Result<A>: ReferenceWriteSubscriptable {
        @inlinable public static var subscriptRoot: ReferenceWritableKeyPath<Sink.Result<A>, Swift.Result<A, Error>> { \.__o }
        @usableFromInline @Published var __o: Swift.Result<A, Error>
        var bag: Bag = []
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
        }.store(in: &sink.bag)
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
        }.store(in: &sink.bag)
    }
}
