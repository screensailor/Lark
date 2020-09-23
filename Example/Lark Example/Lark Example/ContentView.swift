import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            GameOfLife()
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
        .background(Color.blue)
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

