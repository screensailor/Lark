class Brain™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Functions = [String: Func.Type]
    typealias Concept = Brain.Concept

    let functions: Functions = [
        "": Identity.self,
        "+": Sum.self,
        "*": Product.self
    ]
    
    func test() {
        let brain = Brain(functions: functions)
        let o = Sink.Var<JSON>(nil)

        o ...= brain.published("new concept")

        brain.lexicon["new concept"] = Concept(["x", "y"], "+")

        brain["x"] = 2
        brain["y"] = 3
        
        2.times(brain.commit)

        hope(o[]) == 5
    }
    
    func test_2() {
        let brain = Brain(functions: functions)
        let o = Sink.Var<JSON>(nil)
        
        o ...= brain.published("x * (a + b + c)")
        
        brain.lexicon["x * (a + b + c)"] = Concept(
            connections: ["x", "a + b + c"],
            action: "*"
        )
        
        brain.lexicon["a + b + c"] = Concept(
            connections: ["a", "b", "c"],
            action: "+"
        )
        
        brain["a"] = 1
        brain["b"] = 2
        brain["c"] = 3
        brain["x"] = 10
        
        3.times(brain.commit)
        
        hope(o[]) == 60
    }
    
    func test_infinite_synchronous_recusrsion() {
        let brain = Brain(functions: functions)
        
        let a = Sink.Var<JSON>(nil)
        let b = Sink.Var<JSON>(nil)
        
        a ...= brain.published("a")
        b ...= brain.published("b")

        brain.lexicon["a"] = Concept(["b", "increment"], "+")
        brain.lexicon["b"] = Concept(["a", "increment"], "+")
        
        brain["a"] = 1
        brain["b"] = 1
        brain["increment"] = 1
        
        brain.commit()
        
        hope(a[]) == 1
        hope(b[]) == 1
        
        brain.commit()
        
        hope(a[]) == 2
        hope(b[]) == 2
        
        brain.commit()
        
        hope(a[]) == 3
        hope(b[]) == 3
        
        100.times(brain.commit)
        
        hope(a[]) == 103
        hope(b[]) == 103
    }
}