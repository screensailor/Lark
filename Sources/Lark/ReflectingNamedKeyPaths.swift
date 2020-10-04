// TODO:❗️combine with IntOrString as CodingKey to allow r/w into unkeyed containers

public protocol ReflectingNamedKeyPaths {
    static var reflected: KeyPathsAndBreadcrumbs<Self> { get } // TODO:❗️remove this protocol requirement
}

public typealias KeyPathsAndBreadcrumbs<Root> = (
    keyPaths: [[String]: PartialKeyPath<Root>],
    breadcrumbs: [PartialKeyPath<Root>: [String]]
)

public extension ReflectingNamedKeyPaths {
    
    static func reflectedNamedKeyPaths() -> KeyPathsAndBreadcrumbs<Self> {
        Reflection.keyPathsAndBreadcrumbs(in: Self.self)
    }
    
    @inlinable static func keyPath<Value>(
        _ breadcrumb: String...,
        to type: Value.Type = Value.self,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws -> KeyPath<Self, Value> {
        try keyPath(breadcrumb, to: type, function: function, file: file, line: line)
    }
    
    @inlinable static func writableKeyPath<Value>(
        _ breadcrumb: String...,
        to type: Value.Type = Value.self,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws -> WritableKeyPath<Self, Value> {
        try writableKeyPath(breadcrumb, to: type, function: function, file: file, line: line)
    }
    
    static func keyPath<Value>(
        _ breadcrumb: [String],
        to type: Value.Type = Value.self,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws -> KeyPath<Self, Value> {
        guard !breadcrumb.isEmpty else {
            let o = \Self.self
            if let k = o as? KeyPath<Self, Value> {
                return k
            } else {
                throw "Empty breadcrumb requires that Value == Self; got \(Value.self) instead".error(function, file, line)
            }
        }
        guard let pk = Self.reflected.keyPaths[breadcrumb] else {
            throw "'\(breadcrumb.joined(separator: "."))' is not a named key path of \(Self.self) type".error(function, file, line)
        }
        guard let k = pk as? KeyPath<Self, Value> else {
            throw "'\(Self.self).\(breadcrumb.joined(separator: "."))' is not a key path to \(Value.self) value".error(function, file, line)
        }
        return k
    }
    
    static func writableKeyPath<Value>(
        _ breadcrumb: [String],
        to type: Value.Type = Value.self,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws -> WritableKeyPath<Self, Value> {
        let k = try keyPath(breadcrumb, to: type, function: function, file: file, line: line)
        guard let wk = k as? WritableKeyPath<Self, Value> else {
            throw "'\(Self.self).\(breadcrumb.joined(separator: "."))' is not a writable key path".error(function, file, line)
        }
        return wk
    }
}

public extension ReflectingNamedKeyPaths {
    
    subscript<A>(breadcrumb: String..., as type: A.Type = A.self) -> A? {
        self[breadcrumb, as: A.self]
    }
    
    subscript<A>(breadcrumb: [String], as type: A.Type = A.self) -> A? {
        guard !breadcrumb.isEmpty else { return self as? A }
        guard let k = Self.reflected.keyPaths[breadcrumb] else { return nil }
        return self[keyPath: k] as? A
    }
}

public extension Reflection {
    
    static func keyPathsAndBreadcrumbs<Root>(in: Root.Type = Root.self) -> KeyPathsAndBreadcrumbs<Root> {
        let breadcrumbs = self.breadcrumbs(in: Root.self)
        let keyPaths = Dictionary(breadcrumbs.map{ ($1, $0) }){ $1 }
        return (keyPaths, breadcrumbs)
    }
    
    static func breadcrumbs<Root>(in: Root.Type = Root.self) -> [PartialKeyPath<Root>: [String]] {
        Dictionary(allNamedKeyPaths(in: Root.self)){ $1 }
    }
}

public extension Reflection {
    
    typealias KeyPathInfo<Root> = (
        keyPath: PartialKeyPath<Root>,
        breadcrumbs: [String]
    )
    
    static func allNamedKeyPaths<Root>(
        in type: Root.Type,
        at: KeyPathInfo<Root> = (\.self, [])
    ) -> [KeyPathInfo<Root>] {
        
        var accumulated: [KeyPathInfo<Root>] = []
        
        func ƒ<A>(_: A.Type) {

            for (name, path) in Reflection.allNamedKeyPaths(for: A.self) {
                guard !name.starts(with: "_") else { continue }
                let child = (
                    keyPath: at.keyPath.appending(path: path)!,
                    breadcrumbs: at.breadcrumbs + [name]
                )
                let o = allNamedKeyPaths(
                    in: Root.self,
                    at: (child.keyPath, child.breadcrumbs)
                )
                accumulated.append(child)
                accumulated.append(contentsOf: o)
            }
        }
        
        let type = Swift.type(of: at.keyPath).valueType
        _openExistential(type, do: ƒ)

        return accumulated
    }
}
