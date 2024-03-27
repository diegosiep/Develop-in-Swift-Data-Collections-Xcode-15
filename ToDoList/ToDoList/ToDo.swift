//
//  ToDo.swift
//  ToDoList
//
//  Created by Diego Sierra on 22/03/24.
//

import UIKit

struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String? = nil) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    @available(iOS 16.0, *)
    static let archiveURL = documentsDirectory.appending(path: "toDos").appendingPathExtension("plist")
    
    static let archiveURLOldiOS = documentsDirectory.appendingPathComponent("toDos").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]? {
        if #available(iOS 16.0, *) {
            guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
            let propertyDecoder = PropertyListDecoder()
            
            return try? propertyDecoder.decode(Array<ToDo>.self, from: codedToDos)
        } else {
            // Fallback on earlier versions
            guard let codedToDos = try? Data(contentsOf: archiveURLOldiOS) else { return nil }
            let propertyDecoder = PropertyListDecoder()
            
            return try? propertyDecoder.decode(Array<ToDo>.self, from: codedToDos)
        }

    }
    
    static func saveToDos(_ toDos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        if #available(iOS 16.0, *) {
            try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
        } else {
            // Fallback on earlier versions
            try? codedToDos?.write(to: archiveURLOldiOS, options: .noFileProtection)
        }
    }
    
    static func loadSampleToDos() -> [ToDo] {
        let toDo1 = ToDo(title: "To-Do One", isComplete: false, dueDate: Date(), notes: "Notes 1")
        let toDo2 = ToDo(title: "To-Do Two", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let toDo3 = ToDo(title: "To-Do Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        
        return [toDo1, toDo2, toDo3]
    }
    
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
}
