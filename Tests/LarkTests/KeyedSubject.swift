import Lark
import Hope

class KeyedSubject™: Hopes {
    
    private var bag: Bag = []
    
    func test() {
        let o = KeyedSubject<String, Error>()
        let x = Sink.Result<String, Error>("")
        x ...= o / bag
        
        o.send("Hello world!")
        
        hope(x.value) == "Hello world!"
    }
}

private class KeyedSubject<Output, Failure>: Subject where Failure: Error {
    
    let subject = PassthroughSubject<Output, Failure>()
    
    func send(_ value: Output) {
        subject.send(value)
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }
    
    func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }
    
    func receive<S>(subscriber: S)
    where
        S: Subscriber,
        Failure == S.Failure,
        Output == S.Input
    {
        subject.receive(subscriber: subscriber)
    }
}
