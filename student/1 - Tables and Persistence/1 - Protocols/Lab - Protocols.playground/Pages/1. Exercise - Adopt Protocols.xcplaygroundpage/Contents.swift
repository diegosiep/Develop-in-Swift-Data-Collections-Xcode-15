import Foundation
class Human: Equatable, Comparable, Codable {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
     }
    
    static func < (lhs: Human, rhs: Human) -> Bool {
        lhs.age < rhs.age
    }
}

let humanOne = Human(name: "me", age: 19)
let humanTwo = Human(name: "Hugo", age: 20)
//:  Make the `Human` class adopt the `CustomStringConvertible` protocol. Print both of your previously initialized `Human` objects.
extension Human: CustomStringConvertible {
    var description: String {
        "Human(name: \(name), age: \(age))"
    }
}

print(humanOne)
print(humanTwo)

//:  Make the `Human` class adopt the `Equatable` protocol. Two instances of `Human` should be considered equal if their names and ages are identical to one another. Print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are equal to eachother (using `==`). Then print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are not equal to eachother (using `!=`).


print(humanOne == humanTwo)
print(humanOne != humanTwo)

//:  Make the `Human` class adopt the `Comparable` protocol. Sorting should be based on age. Create another three instances of a `Human`, then create an array called `people` of type `[Human]` with all of the `Human` objects that you have initialized. Create a new array called `sortedPeople` of type `[Human]` that is the `people` array sorted by age.
let humanThree = Human(name: "Andrea", age: 33)
let humanFour = Human(name: "Pablo", age: 30)
let humanFive = Human(name: "Maxi", age: 50)

let humanArray = [humanOne, humanTwo, humanThree, humanFour, humanFive]

let sortedHumans = humanArray.sorted(by: <)

print(sortedHumans)

//:  Make the `Human` class adopt the `Codable` protocol. Create a `JSONEncoder` and use it to encode as data one of the `Human` objects you have initialized. Then use that `Data` object to initialize a `String` representing the data that is stored, and print it to the console.
let jsonEncoder = JSONEncoder()

if let encodedHumans = try? jsonEncoder.encode(sortedHumans), let jsonString = String(data: encodedHumans, encoding: .utf8) {
    print(jsonString)
} else {
    print("error")
}
/*:
page 1 of 5  |  [Next: App Exercise - Printable Workouts](@next)
 */
