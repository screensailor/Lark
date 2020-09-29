class DefaultingDictionary™: Hopes {
    
    func test() {
        var o = [String: Int]().defaulting(to: 3)
        
        hope.true(o.isEmpty)
        
        o["one"] = 1
        
        hope.false(o.isEmpty)
        
        o["two"] = 2
        
        hope(o.count) == 2
        
        hope(o[]) == ["one": 1, "two": 2]
        hope(o["two"]) == 2
    }
}

