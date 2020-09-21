import SwiftUI
import Lark
import Peek

struct ContentView: View {
    
    @State var cells: DefaultingDictionary<String, JSON> = .init([:], default: nil)
    
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
        .onTapGesture {
            
            1.peek(signpost: "commit", .begin)
            let o = my.brain.commit().defaulting(to: nil)
            1.peek(signpost: "commit", .end)
            
            2.peek(signpost: "set", .begin)
            cells = o
            2.peek(signpost: "set", .end)
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

