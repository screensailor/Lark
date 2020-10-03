public extension Reflection {
    
    typealias KeyPathInfo<Root> = (
        keyPath: PartialKeyPath<Root>,
        breadcrumbs: [String]
    )
    
    static func allNamedKeyPaths<Root>(
        in type: Root.Type,
        at keyPath: PartialKeyPath<Root> = \.self,
        and breadcrumbs: [String] = []
    ) -> [KeyPathInfo<Root>] {
        
        var accumulated: [KeyPathInfo<Root>] = []
        
        func ƒ<A>(_: A.Type) {

            for (name, path) in Reflection.allNamedKeyPaths(for: A.self) {
                guard !name.starts(with: "_") else { continue }
                let child = (
                    keyPath: keyPath.appending(path: path)!,
                    breadcrumbs: breadcrumbs + [name]
                )
                let o = allNamedKeyPaths(
                    in: Root.self,
                    at: child.keyPath,
                    and: child.breadcrumbs
                )
                accumulated.append(child)
                accumulated.append(contentsOf: o)
            }
        }
        
        let type = Swift.type(of: keyPath).valueType
        _openExistential(type, do: ƒ)

        return accumulated
    }
}
