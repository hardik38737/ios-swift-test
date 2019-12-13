//
//  Note.swift
//  TestApp
//
//

import Foundation

class Note: NSObject, Codable {
    
    var noteDescription: String
    var dateCreated: Date
    
    init(noteDescription: String, dateCreated: Date) {
        self.noteDescription = noteDescription
        self.dateCreated = dateCreated
        
        super.init()
    }
}
