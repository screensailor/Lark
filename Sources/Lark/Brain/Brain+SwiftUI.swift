#if canImport(SwiftUI)
import SwiftUI

extension Brain {
    
    public func binding(to lemma: Lemma) -> Binding<Signal> {
        Binding(
            get: { [weak self] in
                self?[lemma] ?? nil
            },
            set: { [weak self] new in
                self?[lemma] = new
            }
        )
    }
    
    public func binding<A>(to lemma: Lemma, default o: A) -> Binding<A> {
        Binding(
            get: { [weak self] in
                guard let self = self else { return o }
                return self[lemma].as(A.self, default: o)
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
    
    public func binding<A>(to lemma: Lemma) -> Binding<A?> {
        Binding(
            get: { [weak self] in
                guard let self = self else { return nil }
                return try? self[lemma].as(A.self)
            },
            set: { [weak self] new in
                guard let self = self else { return }
                guard let new = new else {
                    self[lemma] = nil
                    return
                }
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
