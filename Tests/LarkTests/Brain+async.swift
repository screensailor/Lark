class Brain™_async: Brain™ {
    
    private var bag: Bag = []
    
    override func tearDown() {
        bag = []
        super.tearDown()
    }

    func test() throws {
        let promise = expectation(description: "!".here())
        
        let lexicon = [
            "alarm": Concept("after", "t", "alarm message"),
        ]
        let brain = try Brain(lexicon, functions)
        let o = Sink.Var<JSON>(nil)
        
        o ...= brain.subject("alarm")
        
        brain["t"] = 0.1
        brain["alarm message"] = "Wakey wakey!"

        hope(o[]) != "Wakey wakey!"
        
        brain.commit()
        
        hope(o[]) != "Wakey wakey!"

        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink{ _ in
            brain.commit()
            if o[] == "Wakey wakey!" { promise.fulfill() }
        } / bag
        
        wait(for: [promise], timeout: 1)
    }
}
