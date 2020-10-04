class Brain™_async: Brain™ {

    func test() throws {
        
        let lexicon = [
            "alarm": Concept("after", "t", "alarm message"),
        ]
        let brain = try Brain(lexicon, functions, on: scheduler.eraseToAnyScheduler())
        let o = Sink.Var<JSON>(nil)
        
        o ...= brain.subject("alarm")
        
        brain["t"] = 2
        brain["alarm message"] = "Wakey wakey!"
        
        brain.commit()

        hope(o[]) == nil
        
        scheduler.advance(by: .seconds(1))
        
        brain.commit()

        hope(o[]) == nil
        
        scheduler.advance(by: .seconds(1))

        brain.commit()
        
        hope(o[]) == "Wakey wakey!"
    }
}
