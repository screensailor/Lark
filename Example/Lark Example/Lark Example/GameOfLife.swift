import SwiftUI
import Lark

struct GameOfLife: View {
    
    @ObservedObject private var brain = GameOfLifeBrain()

    var body: some View {
        HStack(spacing: 0) {
            ForEach(brain.cols) { col in
                VStack(spacing: 0) {
                    ForEach(brain.rows) { row in
                        Rectangle()
                            .foregroundColor(brain.cell(row, col) ? .white : .blue)
                            .cornerRadius(4)
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

private class GameOfLifeBrain: ObservableObject {
    
    let cols = 0 ..< my.cols
    let rows = 0 ..< my.rows
    
    let objectWillChange = ObservableObjectPublisher()
    
    private var brain = try! Brain(my.lexicon, my.functions)
    
    func cell(_ row: Int, _ col: Int) -> Bool {
        brain["cell:\(row):\(col)"].cast(default: false)
    }
    
    func commit() {
        DispatchQueue.main.async {
            self.brain
                .peek(signpost: "commit", .begin)
                .commit()
                .peek(signpost: "commit", .end)
            
            if self.brain.didChange {
                self.objectWillChange.send()
            }
        }
    }
    
    func perturb() {
        
        for col in cols {
            for row in rows {
                if Float.random(in: 0...1) < 0.05 {
                    brain["cell:\(row):\(col)"] = JSON(true)
                }
            }
        }
        
        if brain.didChange {
            objectWillChange.send()
        }
    }
}

private enum my {
    
    static let cols = 25
    static let rows = Int((CGFloat(cols) * aspectRatio).rounded(.down))
    
    static let size = UIScreen.main.nativeBounds.size
    static let aspectRatio = size.height / size.width
}

extension my {
    typealias Lemma = String
    typealias Brain = Lark.Brain<Lemma, JSON>
    typealias State = [Lemma: JSON]
    typealias Concept = Brain.Concept
    typealias Lexicon = [Lemma: Concept]
    typealias Functions = [Lemma: BrainFunction]
}

extension my {
    
    struct GameOfLifeFunction: SyncBrainFunction {
        
        let description = "Game of Life"
        
        func ƒ<X>(x: [X]) throws -> X? where X: BrainWave {
            let x = x.map{ $0.cast(default: false) ? 1 : 0 }
            guard let y = try ƒ(x) else { return nil }
            return try X(y)
        }
        
        private func ƒ(_ x: [Int]) throws -> Bool? {
            guard x.count == 9 else { throw "GameOfLifeFunction error: x.count = \(x.count)".error() }
            let isLive = x[4] != 0
            let n = x.reduce(0, +) - (isLive ? 1 : 0)
            let y = (isLive && n == 2) || n == 3
            return y == isLive ? nil : y
        }
    }
}

extension my {
    
    static let functions: Functions = [
        "Game of Life": GameOfLifeFunction()
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
                    "cell:\(row.prev):\(col.prev)",
                    "cell:\(row.prev):\(col.this)",
                    "cell:\(row.prev):\(col.next)",
                    
                    "cell:\(row.this):\(col.prev)",
                    "cell:\(row.this):\(col.this)",
                    "cell:\(row.this):\(col.next)",
                    
                    "cell:\(row.next):\(col.prev)",
                    "cell:\(row.next):\(col.this)",
                    "cell:\(row.next):\(col.next)",
                ]
                o["cell:\(row.this):\(col.this)"] = Concept("Game of Life", kernel)
            }
        }
        
        return o
    }()
}
