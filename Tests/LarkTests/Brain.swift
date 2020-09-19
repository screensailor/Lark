class Brain™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept

    let functions: [String: BrainFunction] = [
        "": Identity(),
        "+": Sum(),
        "*": Product()
    ]
    
    func test_sum_and_multiply() throws {
        let lexicon = [
            "x * (a + b + c)": Concept(["x", "a + b + c"], "*"),
            "a + b + c": Concept(["a", "b", "c"], "+"),
        ]
        let brain = try Brain(lexicon, functions)
        let o = Sink.Var<JSON>(nil)
        
        o ...= brain["x * (a + b + c)"]
        
        brain["a"] = 1
        brain["b"] = 2
        brain["c"] = 3
        brain["x"] = 10
        
        brain.commit(thoughts: 2)
        
        hope(o[]) == 60
    }

    func test_sum_two_input_nodes() throws {
        let lexicon = [
            "new concept": Concept(["x", "y"], "+"),
        ]
        let brain = try Brain(lexicon, functions)
        let o = Sink.Var<JSON>(nil)

        o ...= brain["new concept"]

        brain["x"] = 2
        brain["y"] = 3
        
        brain.commit()

        hope(o[]) == 5
    }
    
    func test_infinite_synchronous_recusrsion() throws {
        let lexicon = [
            "x": Concept(["x", "increment"], "+")
        ]
        let brain = try Brain(lexicon, functions)
        let x = Sink.Var<JSON>(nil)
        
        x ...= brain["x"]
        
        brain["increment"] = 1
        brain["x"] = 0
        
        brain.commit()
        hope(x[]) == 1
        
        brain.commit()
        hope(x[]) == 2
        
        brain.commit()
        hope(x[]) == 3
        
        brain.commit(thoughts: 100)
        hope(x[]) == 103
    }

    func test_blank_mind() throws {
        let o = Sink.Var<JSON>(nil)
        let mind = try Brain()
        
        o ...= mind["?"]
        mind["?"] = "🙂"
        
        hope(o[]) == nil
        
        mind.commit()
        hope(o[]) == "🙂"
    }
}
