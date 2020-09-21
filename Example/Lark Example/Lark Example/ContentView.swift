import SwiftUI
import Lark
import Peek

struct ContentView: View {
    
    @State var cells: DefaultingDictionary<String, JSON> = .init([:], default: nil)
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    /// - Note: The purpose of this example is not Game of Life performance, but to stress out Lark.
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<my.cols) { col in
                VStack(spacing: 1) {
                    ForEach(0..<my.rows) { row in
                        let isLive = cells["cell:\(row):\(col)"].cast(default: false)
                        Rectangle()
                            .foregroundColor(isLive ? .red : .blue)
                            .cornerRadius(3)
                    }
                }
            }
        }
        .padding()
        .onReceive(timer) { _ in
            peek(signpost: .begin, "commit")
            cells = my.brain.commit().defaulting(to: nil)
            peek(signpost: .end, "commit")
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

