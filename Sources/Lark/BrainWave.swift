public protocol BrainWave: Castable, ExpressibleByNilLiteral, ExpressibleByErrorValue {}

extension JSON: BrainWave {}
