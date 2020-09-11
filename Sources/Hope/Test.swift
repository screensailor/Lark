public typealias hope = Test

public struct Test<T> {
    public let value: () throws -> T
    public let file: StaticString
    public let line: UInt
}

extension Test {
    
    public init(
        _ value: @escaping @autoclosure () throws -> T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        self.value = value
        self.file = file
        self.line = line
    }
}

extension Test {
    
    @inlinable
    public static func == <U>(l: Test, r: @autoclosure () -> U) where T: Equatable {
        guard let r = r() as? T else { return XCTFail("\(U.self) != \(T.self)", file: l.file, line: l.line) }
        XCTAssertEqual(try l.value(), r, file: l.file, line: l.line)
    }
    
    @inlinable
    public static func != <U>(l: Test, r: @autoclosure () -> U) where T: Equatable {
        guard let r = r() as? T else { return }
        XCTAssertNotEqual(try l.value(), r, file: l.file, line: l.line)
    }
    
    @inlinable
    public static func == <U>(l: Test, r: @autoclosure () -> U) where U: Equatable {
        guard let lhs = (try? l.value()) as? U else { return XCTFail("\(U.self) != \(T.self)", file: l.file, line: l.line) }
        XCTAssertEqual(lhs, r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func != <U>(l: Test, r: @autoclosure () -> U) where U: Equatable {
        guard let lhs = (try? l.value()) as? U else { return }
        XCTAssertNotEqual(lhs, r(), file: l.file, line: l.line)
    }
}

extension Test where T: Comparable {
    
    @inlinable
    public static func > (l: Test, r: @autoclosure () throws -> T) {
        XCTAssertGreaterThan(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func < (l: Test, r: @autoclosure () throws -> T) {
        XCTAssertLessThan(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func >= (l: Test, r: @autoclosure () throws -> T) {
        XCTAssertGreaterThanOrEqual(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func <= (l: Test, r: @autoclosure () throws -> T) {
        XCTAssertLessThanOrEqual(try l.value(), try r(), file: l.file, line: l.line)
    }
}

extension Test where T: FloatingPoint {
    
    @inlinable
    public static func ~= (l: Test<T>, r: ClosedRange<T>) {
        let e = (r.upperBound - r.lowerBound) / 2
        XCTAssertEqual(try l.value(), r.lowerBound + e, accuracy: e, file: l.file, line: l.line)
    }
}

extension FloatingPoint {
    
    @inlinable public static func ± (l: Self, r: Self) -> ClosedRange<Self> {
        (l - abs(r)) ... (l + abs(r))
    }
}
