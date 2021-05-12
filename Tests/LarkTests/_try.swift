class Try: Hopes {
    
    private var bag: Bag = []
    
    func test() throws {
        
        let promise = expectation()
        
        let f = Deferred{
            Future<CFAbsoluteTime, Never>{ promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    promise(.success(CFAbsoluteTimeGetCurrent()))
                }
            }
        }.eraseToAnyPublisher()
        
        f
            .handleEvents(
                receiveOutput: { t in
                    print("❓", t)
                }
            )
            .sink{ t in
            print("✅", t)
            promise.fulfill()
        }.store(in: &bag)
        
        wait(for: promise, timeout: 1)
    }
}

