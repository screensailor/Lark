import Peek

public protocol BoxedAny {
    var unboxedAny: Any { get }
    init(_ any: Any, function: String, file: String, line: Int) throws
}

extension BoxedAny {
    
    public init(
        _ any: Any,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws {
        throw "\(Self.self).init(_: Any) not implemented".error()
    }
}

