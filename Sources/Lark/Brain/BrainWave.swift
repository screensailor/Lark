public protocol BrainWave:
    Castable,
    ExpressibleByNilLiteral,
    ExpressibleByErrorValue,
    CustomStringConvertible
{}

extension BrainWave {
    
    @inlinable public static func `catch`(_ ƒ: () throws -> Self) -> Self {
        do {
            return try ƒ()
        } catch let error as BrainError {
            return Self.init(error)
        } catch {
            return Self.init(BrainError(String(describing: error)))
        }
    }
    
    @inlinable public static func `catch`(_ ƒ: () throws -> Self?) -> Self? {
        do {
            return try ƒ()
        } catch let error as BrainError {
            return Self.init(error)
        } catch {
            return Self.init(BrainError(String(describing: error)))
        }
    }
}
