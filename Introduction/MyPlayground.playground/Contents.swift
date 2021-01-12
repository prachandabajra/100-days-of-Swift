import UIKit

// Simple Types
// Variables
var str = "Hello, playground"
str = "Prachanda"

// Strings and integers
var age = 38
var population = 8_000_000

// Multi-line strings
var str1 = """
This goes
over multiple
lines
"""
var str2 = """
This goes \
over multiple \
lines
"""

// Doubles and Booleans
var pi = 3.141
var awesome = true

// String interpolation
var score = 85
var str3 = "Your score war \(score)"
var results = "The test results are here: \(str3)"

// Constants
let taylor = "swift"

// Type annotations
// type inference: Swift is able to infer the type of something based on how you created it.
let str4 = "Hello, playground"
let album: String = "Reputation"
let year: Int = 1989
let height: Double = 1.78
let taylorRocks: Bool = true
var str5: String
str5 = "Prachanda"

// Complex Types
// Arrays
// Note: If you're using type annotations, arrays are written in brackets: [String], [Int], [Double], [Bool].
let john = "John Lennon"
let paul = "Paul McCartney"
let george = "George Harrison"
let ringo = "Ringo Starr"

let beatles = [john, paul, george, ringo]
beatles[1]

// Sets
let colors = Set(["red", "green", "blue"])
let colors2 = Set(["red", "green", "blue", "red", "blue"])

// Tuples
var name = (first: "Taylor", last: "Swift")
name.0
name.first

// Arrays vs sets vs tuples
// Tuples: fixed collection of related values where each item has a precise position or name
// Sets: a collection of values that must be unique or you need to be able to check whether a specific item is in there extremely quickly.
// Arrays: a collection of values that can contain duplicates, or the order of your items matters.
let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville")
let set = Set(["aardvark", "astronaut", "azalea"])
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]

// Dictionaries
// Note: When using type annotations, dictionaries are written in brackets with a colon between your identifier and value types. For example, [String: Double] and [String: String].
let heights = ["Taylor Swift": 1.78, "Ed Sheeran": 1.73]
heights["Taylor Swift"]

// Dictionary default values
let favouriteIceCream = ["Paul": "Chocolate", "Sophie": "Vanilla"]
favouriteIceCream["Paul"]
favouriteIceCream["Charlotte", default: "Unknown"]

// Creating empty collections
// Arrays, sets and dictionaries are called collections, because they collect values together in one place
var teams = [String: String]()
teams["Paul"] = "Red"

var results2 = [Int]()

var words = Set<String>()
var numbers = Set<Int>()

var scores = Dictionary<String, Int>()
var results3 = Array<Int>()

// Enumerations
enum Result {
    case success
    case failure
}
let result4 = Result.failure

// Enum associated values
enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}
let talking = Activity.talking(topic: "football")

// Enum raw values
enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
}
let earth = Planet(rawValue: 2)
