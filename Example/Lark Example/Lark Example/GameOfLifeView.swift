import Lark

struct GameOfLifeView {
    @Binding var color: Color
    @ObservedObject private var brain: GameOfLifeState = .shared
}

extension GameOfLifeView: View {

    var body: some View {
        HStack(spacing: 0) {
            ForEach(brain.cols) { col in
                VStack(spacing: 0) {
                    ForEach(brain.rows) { row in
                        BrainCell(
                            isLive: brain.binding(to: row, col),
                            color: $color
                        )
                    }
                }
            }
        }
        .onReceive(brain.objectWillChange){ _ in
            brain.commit()
        }
        .onTapGesture {
            brain.perturb()
        }
    }
}

private struct BrainCell: View {
    
    @Binding var isLive: Bool
    @Binding var color: Color
    
    var body: some View {
        (isLive ? .white : color).cornerRadius(4)
    }
}

private class GameOfLifeState: ObservableObject {
    
    typealias my = GameOfLifeState
    
    let cols = 0 ..< my.cols
    let rows = 0 ..< my.rows
    
    let objectWillChange = ObservableObjectPublisher()
    
    private var brain = try! Brain(my.lexicon, my.functions)
}

extension GameOfLifeState {
    
    func binding(to row: Int, _ col: Int) -> Binding<Bool> {
        brain.binding(to: "\(row):\(col)", default: false)
    }
    
    func commit() {
        DispatchQueue.main.async { [self] in
            brain
                .peek(signpost: "commit", .begin)
                .commit()
                .peek(signpost: "commit", .end)
            
            if !brain.change.isEmpty {
                objectWillChange.send()
            }
        }
    }
    
    func perturb() {
        for col in cols {
            for row in rows {
                if Float.random(in: 0...1) < 0.1 {
                    brain["\(row):\(col)"] = JSON(true)
                }
            }
        }
        if !brain.change.isEmpty {
            objectWillChange.send()
        }
    }
}

extension GameOfLifeState {
    
    static let shared = GameOfLifeState()

    static let cols = 30
    static let rows = Int((CGFloat(cols) * aspectRatio).rounded(.down))
    
    static let size = UIScreen.main.nativeBounds.size
    static let aspectRatio = size.height / size.width
}

extension GameOfLifeState {
    typealias Lemma = String
    typealias Brain = Lark.Brain<Lemma, JSON>
    typealias Concept = Brain.Concept
    typealias Lexicon = [Lemma: Concept]
    typealias Functions = [Lemma: BrainFunction]
}

struct GameOfLife: SyncBrainFunction {
    
    let description = "Game of Life"
    
    func ƒ<X>(x: [X]) throws -> X? where X: BrainWave {
        let x = x.map{ $0.cast(default: false) ? 1 : 0 }
        guard let y = try ƒ(x) else { return nil }
        return try X(y)
    }
    
    private func ƒ(_ x: [Int]) throws -> Bool? {
        guard x.count == 9 else { throw "\(Self.self) error: x.count = \(x.count)".error() }
        let isLive = x[4] != 0
        let n = x.reduce(0, +) - (isLive ? 1 : 0)
        let y = (isLive && n == 2) || n == 3
        return y == isLive ? nil : y
    }
}

extension GameOfLifeState {
    
    static let functions: Functions = [
        "Game of Life": GameOfLife()
    ]
    
    static let lexicon: Lexicon = {
        
        var o: [Lemma: Concept] = [:]
        
        func idx(_ i: Int, in count: Int) -> Int {
            i < 0 ? count + i : (i > count - 1 ? i - count : i)
        }
        
        for col in 0..<cols {
            for row in 0..<rows {
                let row = (
                    prev: idx(row - 1, in: rows),
                    this: row,
                    next: idx(row + 1, in: rows)
                )
                let col = (
                    prev: idx(col - 1, in: cols),
                    this: col,
                    next: idx(col + 1, in: cols)
                )
                let kernel = [
                    "\(row.prev):\(col.prev)",
                    "\(row.prev):\(col.this)",
                    "\(row.prev):\(col.next)",
                    
                    "\(row.this):\(col.prev)",
                    "\(row.this):\(col.this)",
                    "\(row.this):\(col.next)",
                    
                    "\(row.next):\(col.prev)",
                    "\(row.next):\(col.this)",
                    "\(row.next):\(col.next)",
                ]
                o["\(row.this):\(col.this)"] = Concept("Game of Life", kernel)
            }
        }
        
        return o
    }()
}
