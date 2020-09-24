//
//  LarkingDocument.swift
//  Larking Editor
//
//  Created by Milos Rankovic on 24/09/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct LarkingDocument {
    
    var text: String
    
    init(text: String = "Hello, world!") {
        self.text = text
    }
}

extension LarkingDocument: FileDocument {
    
    static let readableContentTypes: [UTType] = [.plainText]

    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents,
            let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
