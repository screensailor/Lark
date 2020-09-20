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
    
    static let rows = cols * 2
    static let cols = 20
    
    static let lexicon: [String: Concept] = {
        var o: [String: Concept] = [:]
        for col in 0..<cols {
            for row in 0..<rows {
                let kernel = [
                    "cell:\(row):\(col)",
                    
                    "cell:\(row - 1):\(col - 1)",
                    "cell:\(row - 1):\(col - 0)",
                    "cell:\(row - 1):\(col + 1)",
                    
                    "cell:\(row - 0):\(col - 1)",
                    "cell:\(row - 0):\(col + 1)",
                    
                    "cell:\(row + 1):\(col - 1)",
                    "cell:\(row + 1):\(col - 0)",
                    "cell:\(row + 1):\(col + 1)",
                ]
                o["cell:\(row):\(col)"] = Concept("life", kernel)
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
        guard let isLive = x.first?.as(Bool.self, default: false) else { throw "\(After.self) x.count: \(x.count)".error() }
        let n = x.dropFirst().reduce(0){ a, e in a + (e.cast(default: false) ? 1 : 0) }
        return try X(isLive && (2...3).contains(n) || n == 3)
    }
}
