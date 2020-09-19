@_exported import Peek
@_exported import Hope
@_exported import Lark

class Lark™: Hopes {

    func test() {
        let o = Sink.Var<JSON>(nil)
        let mind = Mind<String, JSON>()
        o ...= mind.subjects["?"]
        mind["?"] = "🙂"
        hope(o[]) == nil
        mind.commit()
        hope(o[]) == "🙂"
    }
}

protocol BrainWave: Castable, ExpressibleByNilLiteral, ExpressibleByErrorValue {}
extension JSON: BrainWave {}

class Mind<Lemma, Signal> where
    Lemma: Hashable,
    Signal: BrainWave
{
    typealias State = DefaultingDictionary<Lemma, Signal>
    typealias Subjects = DefaultInsertingDictionary<Lemma, CurrentValueSubject<Signal, Never>>
    
    private var state = [Lemma: Signal]().defaulting(to: nil)
    private var writes: [Lemma: Signal] = [:]
    lazy var subjects = Subjects([:]){ [weak self] key in .init(self?.state[key] ?? nil) }
    
    
}

extension Mind {

    public subscript() -> [Lemma: Signal] {
        state[]
    }

    public subscript(lemma: Lemma) -> Signal {
        get { state[lemma] }
        set { writes[lemma] = newValue }
    }

    func commit() {
        state[].merge(writes){ $1 }
        for (lemma, signal) in writes {
            subjects[lemma]?.send(signal)
        }
        writes.removeAll(keepingCapacity: true)
    }
}
