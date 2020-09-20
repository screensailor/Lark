import SwiftUI
import Lark

struct ContentView: View {
    
    @State var cells: DefaultingDictionary<String, JSON> = .init([:], default: nil)
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<my.cols) { col in
                VStack(spacing: 1) {
                    ForEach(0..<my.rows) { row in
                        let cell = "cell:\(row):\(col)"
                        let isLive = cells[cell].cast(default: false)
                        Rectangle()
                            .foregroundColor(isLive ? .red : .blue)
                            .cornerRadius(3)
                    }
                }
            }
        }
        .padding()
        .onTapGesture {
            my.brain.commit()
            cells = my.brain[].defaulting(to: nil)
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

