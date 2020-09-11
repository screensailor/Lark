public protocol JSON {
    
}

extension Int: JSON {}
extension String: JSON {}

extension Dictionary: JSON where Key == String {}
extension Array: JSON {}

public typealias JSONIndex = IntOrString
public typealias JSONPath = [IntOrString]

extension JSON {
    
    @inlinable public subscript(path: JSONIndex...) -> Any? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    public subscript(path: JSONPath) -> Any? {
        get {
            guard !path.isEmpty else { return self }
            fatalError()
        }
        set {
        
        }
    }
}

extension Dictionary where Key == String {
    
    @inlinable public subscript(path: JSONIndex...) -> Any? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    public subscript(path: JSONPath) -> Any? {
        get { fatalError() }
        set {}
    }
}

extension Array {
    
    @inlinable public subscript(path: JSONIndex...) -> Any? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    public subscript(path: JSONPath) -> Any? {
        get { fatalError() }
        set {}
    }
}
