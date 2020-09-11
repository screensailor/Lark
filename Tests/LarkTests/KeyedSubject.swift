import Lark
import Hope

class KeyedSubject™: Hopes {
    
    private var bag: Bag = []
    
    func test() {
        let o = KeyedSubject<String, String>()
        let x = Sink.Result(String?.none)
        x ...= o["World!"] / bag
        
        o.send("Hello", to: "World!")
        
        hope(x.value) == "Hello"
    }
}

private class KeyedSubject<Key, Value> where Key: Hashable {
    
    private(set) var state: [Key: Value]
    private(set) var subscriptions: [Key: CurrentValueSubject<Value?, Never>] = [:]
    
    init(_ state: [Key: Value] = [:]) {
        self.state = state
    }
    
    subscript(key: Key) -> CurrentValueSubject<Value?, Never> {
        let o = CurrentValueSubject<Value?, Never>(state[key])
        subscriptions[key] = o
        return o
    }
    
    func send(_ value: Value, to key: Key) {
        state[key] = value
        subscriptions[key]?.send(value)
    }
}
