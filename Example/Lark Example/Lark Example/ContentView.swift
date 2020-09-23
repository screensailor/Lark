import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            GameOfLife()
            VStack{
                Text("Game of Lark")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.white)
                Text("Tap to re/start")
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .statusBar(hidden: true)
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

