class Brain_async™: Hopes {
    
    typealias Brain = Lark.Brain<String, JSON>
    typealias Lexicon = Brain.Lexicon
    typealias Concept = Brain.Concept

    let functions: [String: BrainFunction] = [
        "": Identity(),
        "+": Sum(),
        "*": Product(),
        "after": After()
    ]
    
    private var bag: Bag = []
    
    func test() throws {
        let promise = expectation(description: "!".here())
        
        let lexicon = [
            "alarm": Concept("after", "t", "alarm message"),
            "count": Concept("+", "count", "t")
        ]
        let brain = try Brain(lexicon, functions)
        let o = Sink.Var<JSON>(nil)
        
        o ...= brain["alarm"]
        
        brain["t"] = 0.5
        brain["alarm message"] = "Wakey wakey!"

        hope(brain["alarm"]) != "Wakey wakey!"
        
        brain.commit()
        
        hope(brain["alarm"]) != "Wakey wakey!"

        Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().sink{ _ in
            brain.commit()
            if brain["alarm"] == "Wakey wakey!" { promise.fulfill() }
        } / bag
        
        wait(for: [promise], timeout: 1)
    }
}
