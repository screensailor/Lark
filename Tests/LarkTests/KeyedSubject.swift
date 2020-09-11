import Lark
import Hope

class KeyedSubject™: Hopes {
    
    private var bag: Bag = []
    
    func test() {
        let o = KeyedSubject<String, String>()
        
        let x = Sink.Var<String>()
        x ...= o["World!"] / bag
        hope(x.value) == nil
        
        o.send("Hello", to: "World!")
        
        hope(x.value) == "Hello"
        
        let y = Sink.Var<String>()
        y ...= o["World!"] / bag
        hope(y.value) == "Hello"
        
        o.send("Bye bye", to: "World!")
        
        hope(x.value) == "Bye bye"
        hope(y.value) == x.value
    }
}

private class KeyedSubject<Key, Value> where Key: Hashable {
    
    private(set) var state: [Key: Value]
    private(set) var subscriptions: [Key: CurrentValueSubject<Value?, Never>] = [:]
    
    init(_ state: [Key: Value] = [:]) {
        self.state = state
    }
    
    subscript(key: Key) -> CurrentValueSubject<Value?, Never> {
        var o: CurrentValueSubject<Value?, Never>
        if let x = subscriptions[key] {
            o = x
        } else {
            o = .init(state[key])
            subscriptions[key] = o
        }
        return o
    }
    
    func send(_ value: Value, to key: Key) {
        state[key] = value
        subscriptions[key]?.send(value)
    }
}
