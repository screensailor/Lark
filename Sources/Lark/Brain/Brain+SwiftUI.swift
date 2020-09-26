#if canImport(SwiftUI)
import SwiftUI

extension Brain {
    
    public func binding<A>(to lemma: Lemma, default o: A) -> Binding<A> {
        Binding(
            get: { [weak self] in
                guard let self = self else { return o }
                return self.state(of: lemma).as(A.self, default: o)
            },
            set: { [weak self] new in
                guard let self = self else { return }
                do {
                    self[lemma] = try Signal(new)
                } catch let error as BrainError {
                    self[lemma] = Signal(error)
                } catch {
                    self[lemma] = Signal(.init(String(describing: error)))
                }
            }
        )
    }
}
#endif
