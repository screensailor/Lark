import SwiftUI

struct ContentView: View {
    
    @State var color: Color = .blue

    var body: some View {
        ZStack {
            GameOfLife(color: $color)
            VStack{
                Text("Game of Lark")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.white)
                Text("Tap to bring 5% of cells to life")
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .statusBar(hidden: true)
        .background(color)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

