import Peek

open class URI {
    
    @usableFromInline let __url: URL
    
    public required init(_ url: URL) { __url = url }

    @inlinable public func callAsFunction() -> URL { __url }
}

extension URI: Equatable {
    @inlinable public static func == (lhs: URI, rhs: URI) -> Bool {
        return lhs.__url == rhs.__url
    }
}

extension URI: Hashable {
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(__url)
    }
}

extension URI: CustomDebugStringConvertible {
    @inlinable public var debugDescription: String {
        __url.absoluteString
    }
}

extension URI {
    public func `var`<Var: URI>(type: Var.Type = Var.self) -> Var {
        Var(__url.appendingPathComponent(String(describing: Var.self)))
    }
}

extension URI { // @testable
    
    @inlinable convenience init(_ url: String) {
        self.init(URL(string: url)!)
    }
}
