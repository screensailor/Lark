@_exported import Peek
@_exported import Hope
@_exported import Lark

class Lark™: Hopes {

    func test() throws {
        let o = Sink.Var<JSON>(nil)
        let mind = try Mind<String, JSON>()
        o ...= mind["?"]
        mind["?"] = "🙂"
        hope(o[]) == nil
        mind.commit()
        hope(o[]) == "🙂"
    }
}

extension JSON: BrainWave {}

public protocol BrainWave: Castable, ExpressibleByNilLiteral, ExpressibleByErrorValue {}

public protocol BrainFunc: CustomStringConvertible {
    func callAsFunction<X>(x: [X], file: String, line: Int) throws -> Future<X, Never> where X: BrainWave
}

public typealias BrainError = CodeLocation.Error

final public class Mind<Lemma, Signal> where
    Lemma: Hashable,
    Signal: BrainWave
{
    public typealias Lexicon = [Lemma: Concept]
    public typealias Functions = [Lemma: BrainFunc]
    
    public let lexicon: [Lemma: Concept]
    public let functions: [Lemma: BrainFunc]

    public typealias State = DefaultingDictionary<Lemma, Signal>
    public typealias Subject = CurrentValueSubject<Signal, Never>
    public typealias Subjects = DefaultInsertingDictionary<Lemma, Subject>

    private var state = [Lemma: Signal]().defaulting(to: nil)
    private var change: [Lemma: Signal] = [:]
    private var thoughts: [Lemma: Signal] = [:]
    
    private lazy var subjects = Subjects([:]){ [weak self] lemma in
        guard let self = self else { return Subject(nil) }
        return Subject(self.state[lemma])
    }

    private lazy var nervs = Subjects([:]){ [weak self] lemma in
        guard let self = self else { return Subject(nil) }
        return Subject(self.state[lemma])
    }
    
    private var neurons: [Lemma: Neuron] = [:]

    public init(_ lexicon: Lexicon = [:], _ functions: Functions = [:], _ state: [Lemma: Signal] = [:]) throws {
        self.state = state.defaulting(to: nil)
        self.lexicon = lexicon
        self.functions = functions
        
        for (lemma, _) in lexicon {
            neurons[lemma] = try Neuron(lemma, in: self)
        }
    }
}

extension Mind {
    
    public subscript(lemma: Lemma) -> Subject {
        subjects[lemma]
    }

    public subscript() -> [Lemma: Signal] {
        get { state[] }
        set { change = newValue }
    }

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { change[lemma] = newValue }
    }

    @discardableResult
    public func commit() -> [Lemma: Signal] {
        let writes = self.change
        self.change.removeAll(keepingCapacity: true)
        state[].merge(writes){ $1 }
        for (lemma, signal) in writes {
            subjects[lemma]?.send(signal)
        }
        return writes
    }
}

extension Mind {

    public struct Concept: Hashable {
        public let connections: [Lemma]
        public let function: Lemma
    }
}

extension Mind.Concept {
    
    public init(_ connections: [Lemma] = [], _ function: Lemma) {
        self.connections = connections
        self.function = function
    }
}

extension Mind {
    
    public class Neuron {
        
        public let lemma: Lemma
        public let concept: Concept
        public let function: BrainFunc
        
        public private(set) var signals: [Signal] = [] { didSet { hasUpdates = true } }
        public private(set) var hasUpdates: Bool = false
        
        private var bag: Set<AnyCancellable> = []
        
        init(_ lemma: Lemma, in mind: Mind) throws {
            guard let concept = mind.lexicon[lemma] else {
                throw "Missing concept for lemma '\(lemma)'".error()
            }
            guard let function = mind.functions[concept.function] else {
                throw "Function '\(concept.function)' not found for concept '\(lemma)'".error()
            }
            
            self.lemma = lemma
            self.concept = concept
            self.function = function
            
            self.signals = Array(repeating: nil, count: concept.connections.count) // TODO: Signal.init(Peek.Error("Uninitialized"))
            
            for (i, connection) in concept.connections.enumerated() {
                mind.nervs[connection].sink{ [weak self] signal in
                    self?.signals[i] = signal
                }
                .store(in: &self.bag)
            }
        }
    }
}
