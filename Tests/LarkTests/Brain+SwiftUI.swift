import SwiftUI

class Brain_and_SwiftUI™: Brain™ {
    
    func test() throws {
        
        struct Control: View {
            @Binding var text: String
            var body: some View { Spacer() }
        }
        
        struct UI: View {
            @State var brain = try! Brain()
            var body: some View {
                Control(text: brain.binding(to: "smile", default: "😞"))
            }
        }

        let ui = UI()
        let control = ui.body as! Control
        
        hope(control.text) == "😞"
        
        control.text = "🙂"
        
        ui.brain.commit()
        
        hope(ui.brain["smile"]) == "🙂"
        
        ui.brain["smile"] = "😅"
        
        ui.brain.commit()
        
        hope(control.text) == "😅"
    }
}
