//
//  LarkingEditorApp.swift
//  Larking Editor
//
//  Created by Milos Rankovic on 24/09/2020.
//

import SwiftUI

@main
struct LarkingEditorApp: App {
    
    var body: some Scene {
        DocumentGroup(newDocument: LarkingDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
