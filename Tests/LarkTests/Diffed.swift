class Diffed™: Hopes {
    
    func test() {
        
        
    }
}

public struct AnyWrite<Root> {
    
    public var keyPath: PartialKeyPath<Root>
    public var write: (inout Root) -> ()
    
    public init<Value>(set keyPath: WritableKeyPath<Root, Value>, to value: Value) {
        self.keyPath = keyPath
        self.write = { $0[keyPath: keyPath] = value }
    }
}
