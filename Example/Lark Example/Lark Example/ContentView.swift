import SwiftUI
import Lark

struct ContentView: View {
    
    @State var cells = [String: JSON]().defaulting(to: nil)
    
    static let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()
    
    /// - Note: The purpose of this example is not Game of Life performance, but to stress out Lark.
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<my.cols) { col in
                VStack(spacing: 0) {
                    ForEach(0..<my.rows) { row in
                        let id = "cell:\(row):\(col)"
                        let isLive = cells[id].cast(default: false)
                        Rectangle().id(id)
                            .foregroundColor(isLive ? .blue : .white)
                            .cornerRadius(4)
                    }
                }.id("col:\(col)")
            }
        }
        .statusBar(hidden: true)
        .ignoresSafeArea()
        .onReceive(Self.timer) { _ in
            1.peek(signpost: "commit", .begin)
            cells = my.brain.commit().defaulting(to: nil)
            1.peek(signpost: "commit", .end)
        }
        .onTapGesture {
            my.brain[] = my.state
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

