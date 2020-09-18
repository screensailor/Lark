extension Brain {

    public class Neuron {
        
        public let lemma: Lemma
        
        public private(set) var concept: Concept? { didSet { connectionsBag = [] } }
        public private(set) var signals: [Signal] = [] { didSet { hasUpdates = true } }
        public private(set) var hasUpdates: Bool = false
        
        private var function: Func?
        private var brain: Brain? { didSet { emptyBags() } }
        
        private var conceptBag: Set<AnyCancellable> = []
        private var connectionsBag: Set<AnyCancellable> = []
        
        init(_ lemma: Lemma, in brain: Brain) {
            self.lemma = lemma
            self.brain = brain
            self.connect()
        }
        
        func commit() {
            guard hasUpdates, let brain = brain, let function = function else { return }
            hasUpdates = false
            do {
                brain[lemma] = try function(self.signals)
            } catch {
                brain[lemma] = Signal.init(BrainError(error))
            }
        }

        private func connect() {
            guard let brain = brain else { return }
            let lemma = self.lemma
            brain.lexicon.published[lemma].sink{ [weak self] concept in
                guard let self = self, let brain = self.brain else { return }
                
                self.concept = concept
                self.function = concept.flatMap{ brain.functions[$0.action]?.init() }
                
                guard let concept = concept else { return }
                guard self.function != nil else {
                    brain[lemma] = Signal.init("No function '\(concept.action)' for concept '\(lemma)'".error())
                    return
                }
                
                self.signals = Array(repeating: nil, count: concept.connections.count) // TODO: Signal.init(Peek.Error("Uninitialized"))
                
                for (i, connection) in concept.connections.enumerated() {
                    if brain.network[connection] == nil {
                        brain.network[connection] = Neuron(connection, in: brain)
                    }
                    brain.state.published[connection].sink{ [weak self] signal in
                        self?.signals[i] = signal // TODO: equality check?
                    }
                    .store(in: &self.connectionsBag)
                }
            }
            .store(in: &conceptBag)
        }
        
        private func emptyBags() {
            conceptBag = []
            connectionsBag = []
        }
        
        deinit {
            emptyBags()
            brain?[].removeValue(forKey: lemma)
        }
    }
}
