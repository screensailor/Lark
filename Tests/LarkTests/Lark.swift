@_exported import Peek
@_exported import Hope
@_exported import Lark

class Lark™: Hopes {

    func test() {
        let o = Sink.Var<JSON>(nil)
        let mind = Mind<String, JSON>()
        o ...= mind["?"]
        mind["?"] = "🙂"
        hope(o[]) == nil
        mind.commit()
        hope(o[]) == "🙂"
    }
}

public protocol BrainWave: Castable, ExpressibleByNilLiteral, ExpressibleByErrorValue {}
extension JSON: BrainWave {}

final public class Mind<Lemma, Signal> where
    Lemma: Hashable,
    Signal: BrainWave
{
    public typealias State = DefaultingDictionary<Lemma, Signal>
    public typealias Subject = CurrentValueSubject<Signal, Never>
    public typealias Subjects = DefaultInsertingDictionary<Lemma, Subject>
    
    private var state = [Lemma: Signal]().defaulting(to: nil)
    private var writes: [Lemma: Signal] = [:]
    private lazy var subjects = Subjects([:]){ [weak self] key in .init(self?.state[key] ?? nil) }
    
    
}

extension Mind {
    
    public subscript(lemma: Lemma) -> Subject {
        subjects[lemma]
    }

    public subscript() -> [Lemma: Signal] {
        get { state[] }
        set { writes = newValue }
    }

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { writes[lemma] = newValue }
    }

    @discardableResult
    public func commit() -> [Lemma: Signal] {
        let writes = self.writes
        self.writes.removeAll(keepingCapacity: true)
        state[].merge(writes){ $1 }
        for (lemma, signal) in writes {
            subjects[lemma]?.send(signal)
        }
        return writes
    }
}
