public protocol ReflectingdNamedKeyPaths {
    static var reflected: KeyPathsAndBreadcrumbs<Self> { get }
}

public extension ReflectingdNamedKeyPaths {
    
    static func reflectedNamedKeyPaths() -> KeyPathsAndBreadcrumbs<Self> {
        Reflection.keyPathsAndBreadcrumbs(in: Self.self)
    }
    
    subscript<A>(breadcrumb: String..., as type: A.Type = A.self) -> A? {
        self[breadcrumb, as: A.self]
    }
    
    subscript<A>(breadcrumb: [String], as type: A.Type = A.self) -> A? {
        guard !breadcrumb.isEmpty else { return self as? A }
        guard let k = Self.reflected.keyPaths[breadcrumb] else { return nil }
        return self[keyPath: k] as? A
    }
}

public typealias KeyPathsAndBreadcrumbs<Root> = (
    keyPaths: [[String]: PartialKeyPath<Root>],
    breadcrumbs: [PartialKeyPath<Root>: [String]]
)

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
