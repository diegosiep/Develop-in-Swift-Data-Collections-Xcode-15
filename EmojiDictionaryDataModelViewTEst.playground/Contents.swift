import UIKit

var greeting = "Hello, playground"

struct Emoji: Comparable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    var section: Section
    
    static func < (lhs: Emoji, rhs: Emoji) -> Bool {
        return lhs.name < rhs.name
    }
}

enum Section: String, CaseIterable, Comparable {
    case smileysAndPeople = "Smileys & People"
    case activity = "Activity"
    case animalsAndNature = "Animals & Nature"
    case foodAndDrink = "Food & Drink"
    case symbols = "Symbols"
    case objects = "Objects"
    case travelAndPlaces = "Travel & Places"
    case flags = "Flags"
    
    static func < (lhs: Section, rhs: Section) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
}

let emojis = [Emoji(symbol: "😃", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness", section: .smileysAndPeople),
              Emoji (symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure", section: .smileysAndPeople),
              Emoji (symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive", section: .smileysAndPeople),
              
              Emoji (symbol: "🧑‍💻", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming", section: .activity),
              Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game", section: .activity),
              Emoji(symbol: "🏕️", name: "Tent", description: "A small tent.", usage: "camping", section: .activity),
              Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying", section: .activity),
              
              Emoji (symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow", section: .animalsAndNature),
              Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory", section: .animalsAndNature),
              
              Emoji (symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti", section: .foodAndDrink),
              
              Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness", section: .symbols),
              Emoji(symbol: "💤", name: "Snore", description: "Three blue''z''s.", usage: "tired, sleepiness", section: .symbols),
              
              Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion", section: .objects)]


let emojisBySection = emojis.reduce(into: [Section: [Emoji]]()) { partialResult, emoji in
    let section: Section
    section = emoji.section
    
    partialResult[section, default: [].sorted()].append(emoji)
}


let emojisSections = [Section](emojisBySection.keys).sorted()

emojisSections[0].rawValue

let indexPath = IndexPath(row: 0, section: 0)
let emojiSectionToDeuqe = emojisSections[indexPath.section]
let emojiToDeque = emojisBySection[emojiSectionToDeuqe]?[indexPath.row]


let emojiSection = emojisSections[0]
let emojisInSection = emojisBySection[emojiSection] ?? []
