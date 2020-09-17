public typealias Bag = Set<AnyCancellable>

extension Cancellable {
    
    @inlinable public static func / (lhs: Self, rhs: inout Bag) {
        lhs.store(in: &rhs)
    }
}

extension Publisher {
    
    @inlinable public func filter<A>(_: A.Type = A.self) -> Publishers.CompactMap<Self, A> {
        compactMap{ $0 as? A }
    }
    
    @inlinable public func filter<Root, Property>(_ k: KeyPath<Root, Property>) -> Publishers.CompactMap<Self, Property> {
        compactMap{ ($0 as? Root)?[keyPath: k] }
    }
    
    @inlinable public func compacted<A>() -> Publishers.CompactMap<Self, A> where Output == A? {
        compactMap{ $0 }
    }
}

