import SpriteKit

class KeyPath™: Hopes {

    func test_SKScene() {
        let x = SKScene(size: .init(width: 1, height: 2))
        keyPaths(of: x) ¶ "✅"
    }
    
    func test_CGRect() {
        let x = CGRect(x: 1, y: 2, width: 3, height: 4)
        keyPaths(of: x) ¶ "✅"
    }
}

extension CGRect {
    public static let keyPaths = [
        "CGRect.origin": \CGRect.origin,
        "CGRect.origin.x": \CGRect.origin.x,
        "CGRect.origin.y": \CGRect.origin.y,
        "CGRect.size": \CGRect.size,
        "CGRect.size.width": \CGRect.size.width,
        "CGRect.size.height": \CGRect.size.height,
    ]
    public static let keyPathsSerialized = Dictionary(keyPaths.map{ ($1, $0) }){ $1 }
}

private func keyPaths<T>(of x: T) -> String {
    var o = ""
    print("extension \(T.self) {", to: &o)
    print("\tpublic static let keyPaths = [", to: &o)
    traverse(x){ path in
        let key = "\(T.self).\(path.joined(separator: "."))"
        print("\t\t\"\(key)\":", "\\\(key),", to: &o)
        return true
    }
    print("\t]", to: &o)
    print("\tpublic static let keyPathsSerialized = Dictionary(keyPaths.map{ ($1, $0) }){ $1 }", to: &o)
    print("}", to: &o)
    return o
}

private func traverse(_ any: Any, path: [String] = [], _ doContinue: (_ path: [String]) -> Bool) {
    let m = Mirror(reflecting: any)
    
    for child in m.superclassMirror?.children ?? .init([]) {
        guard let name = child.label else { continue }
        let path = path + [name]
        guard doContinue(path) else { return }
        traverse(child.value, path: path, doContinue)
    }
    
    for child in m.children {
        guard let name = child.label else { continue }
        let path = path + [name]
        guard doContinue(path) else { return }
        traverse(child.value, path: path, doContinue)
    }
    
    for child in m.customMirror.children {
        guard let name = child.label else { continue }
        let path = path + [name]
        guard doContinue(path) else { return }
        traverse(child.value, path: path, doContinue)
    }
}
