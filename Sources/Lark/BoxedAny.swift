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
        throw BoxedAnyError("\(Self.self).init(_: Any) not implemented")
    }
}

public struct BoxedAnyError: Swift.Error, CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String
    @inlinable public var debugDescription: String { description }
    @inlinable init(
        _ description: String = "",
        _ function: String = #function,
        _ file: String = #file,
        _ line: Int = #line
    ){
        self.description = "BoxedAnyError(\(description) at: \(here(function, file, line)))"
    }
}
