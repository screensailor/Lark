struct ContentView: View {
    
    @State var color: Color = .blue

    var body: some View {
        ZStack {
            GameOfLifeView(color: $color)
            VStack{
                Text("Game of Lark")
                    .font(.system(.largeTitle, design: .rounded))
                Text("Tap to bring 10% of cells to life")
                    .font(.system(.callout, design: .rounded))
            }
        }
        .statusBar(hidden: true)
        .background(color)
        .foregroundColor(.white)
        .ignoresSafeArea()
    }
}
