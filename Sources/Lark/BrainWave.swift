public protocol BrainWave:
    Castable,
    ExpressibleByNilLiteral,
    ExpressibleByErrorValue,
    CustomStringConvertible
{}

extension JSON: BrainWave {}
