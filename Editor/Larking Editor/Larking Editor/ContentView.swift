//
//  ContentView.swift
//  Larking Editor
//
//  Created by Milos Rankovic on 24/09/2020.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var document: LarkingDocument

    var body: some View {
        return TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(LarkingDocument()))
    }
}

