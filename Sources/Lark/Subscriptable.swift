public protocol Subscriptable {
    associatedtype SubscriptRoot
    static var subscriptRoot: KeyPath<Self, SubscriptRoot> { get }
}

extension Subscriptable {
    
    @inlinable public subscript<A>(dynamicMember keyPath: KeyPath<SubscriptRoot, A>) -> A {
        self[keyPath: Self.subscriptRoot.appending(path: keyPath)]
    }
    
    @inlinable public subscript<A>(_ keyPath: KeyPath<SubscriptRoot, A>) -> A {
        self[keyPath: Self.subscriptRoot.appending(path: keyPath)]
    }
    
    @inlinable public subscript() -> SubscriptRoot {
        self[keyPath: Self.subscriptRoot]
    }
}

public protocol WriteSubscriptable {
    associatedtype SubscriptRoot
    static var subscriptRoot: WritableKeyPath<Self, SubscriptRoot> { get }
}

extension WriteSubscriptable {
    
    @inlinable public subscript<A>(dynamicMember keyPath: WritableKeyPath<SubscriptRoot, A>) -> A {
        get { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] }
        set { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] = newValue }
    }
    
    @inlinable public subscript<A>(_ keyPath: WritableKeyPath<SubscriptRoot, A>) -> A {
        get { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] }
        set { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] = newValue }
    }
    
    @inlinable public subscript() -> SubscriptRoot {
        get { self[keyPath: Self.subscriptRoot] }
        set { self[keyPath: Self.subscriptRoot] = newValue }
    }
}

public protocol ReferenceWriteSubscriptable {
    associatedtype SubscriptRoot
    static var subscriptRoot: ReferenceWritableKeyPath<Self, SubscriptRoot> { get }
}

extension ReferenceWriteSubscriptable {
    
    @inlinable public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<SubscriptRoot, A>) -> A {
        get { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] }
        set { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] = newValue }
    }
    
    @inlinable public subscript<A>(_ keyPath: WritableKeyPath<SubscriptRoot, A>) -> A {
        get { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] }
        set { self[keyPath: Self.subscriptRoot.appending(path: keyPath)] = newValue }
    }
    
    @inlinable public subscript() -> SubscriptRoot {
        get { self[keyPath: Self.subscriptRoot] }
        set { self[keyPath: Self.subscriptRoot] = newValue }
    }
}

