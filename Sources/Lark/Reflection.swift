public extension Reflection {
    
    static func breadcrumbs<Root>(in: Root.Type = Root.self) -> [PartialKeyPath<Root>: [String]] {
        Dictionary(allNamedKeyPaths(in: Root.self)){ _, last in
            last.peek("Multiple keys found in \(Root.self). Choosing last.", as: .info)
        }
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
