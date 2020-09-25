//
//  ContentView.swift
//  Larking Editor
//
//  Created by Milos Rankovic on 24/09/2020.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var document: LarkingDocument
    
    @State var commandLine: String = ""

    var body: some View {
        // TextEditor(text: $document.text)
        VStack {
            Text("above").frame(height: 300)
            
            TextField(
                "Command line",
                text: $commandLine,
                onEditingChanged: onEditingChanged,
                onCommit: onCommit
            )
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
            
            Text("below").frame(height: 300)
        }
        .padding()
        .background(Color.white)
    }
    
    func onEditingChanged(_ x: Bool) {
        
    }
    
    func onCommit() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(LarkingDocument()))
    }
}

extension NSTextField {
    
    open override var focusRingType: NSFocusRingType {
        get { .none } set {}
    }
}
