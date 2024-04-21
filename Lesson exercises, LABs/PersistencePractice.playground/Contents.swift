import UIKit

struct Note: Codable {
    let title: String
    let text: String
    let timestamp: Date
}

let newNote = Note(title: "Grocery run", text: "Pick up a mayonnaise", timestamp: Date())

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let archiveURL = documentsDirectory.appending(path: "notes_test").appendingPathExtension("plist")

let propertyListEncoder = PropertyListEncoder()
let encodedNote = try? propertyListEncoder.encode(newNote)

try? encodedNote?.write(to: archiveURL, options: .noFileProtection)

let propertyListDecoder = PropertyListDecoder()
if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedNote = try? propertyListDecoder.decode(Note.self, from: retrievedNoteData) {
    print(decodedNote)
}

