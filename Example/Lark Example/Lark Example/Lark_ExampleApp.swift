//
//  Lark_ExampleApp.swift
//  Lark Example
//
//  Created by Milos Rankovic on 20/09/2020.
//

import SwiftUI
import Lark

typealias Brain = Lark.Brain<String, JSON>
typealias Concept = Brain.Concept

@main
struct Lark_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum my {
    
    static let brain = try! Brain(lexicon, functions, state)
    
    static let functions: [String: BrainFunction] = [
        "life": GameOfLife()
    ]
    
    static let size = UIScreen.main.nativeBounds.size
    static let ratio = size.height / size.width
    static let rows = Int((CGFloat(cols) * ratio).rounded(.down))
    static let cols = 25
    
    static func idx(_ i: Int, in count: Int) -> Int {
        i < 0 ? count + i : (i > count - 1 ? i - count : i)
    }
    
    static let lexicon: [String: Concept] = {
        var o: [String: Concept] = [:]
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
                    "cell:\(row.this):\(col.this)",
                    
                    "cell:\(row.prev):\(col.prev)",
                    "cell:\(row.prev):\(col.this)",
                    "cell:\(row.prev):\(col.next)",
                    
                    "cell:\(row.this):\(col.prev)",
                    "cell:\(row.this):\(col.next)",
                    
                    "cell:\(row.next):\(col.prev)",
                    "cell:\(row.next):\(col.this)",
                    "cell:\(row.next):\(col.next)",
                ]
                o["cell:\(row.this):\(col.this)"] = Concept("life", kernel)
            }
        }
        return o
    }()

    static var state: [String: JSON] {
        var o: [String: JSON] = [:]
        for col in 0..<cols {
            for row in 0..<rows {
                o["cell:\(row):\(col)"] = JSON(Bool.random())
            }
        }
        return o
    }
}

public struct GameOfLife: SyncBrainFunction {

    public let description = "Game of Life"

    public init() {}

    public func ƒ<X>(x: [X]) throws -> X where X: BrainWave {
        guard x.count == 9 else { throw "\(After.self) x.count: \(x.count)".error() }
        let isLive = x[0].as(Bool.self, default: false)
        let n = x.dropFirst().reduce(0){ a, e in a + (e.cast(default: false) ? 1 : 0) }
        return try X((isLive && n == 2) || n == 3)
    }
}
