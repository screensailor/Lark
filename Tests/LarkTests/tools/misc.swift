extension Int {
    
    public func times<Ignore>(_ ƒ: () throws -> Ignore) rethrows {
        guard self > 0 else { return }
        for _ in 1...self { _ = try ƒ() }
    }
}
