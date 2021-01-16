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

// Complex Types -----------------------------------------------------------------------------------------------------------------------------
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

// Operators and conditions -----------------------------------------------------------------------------------------------------------------------------
// Operator overloading
let meaningOfLife = 42
let doubleMeaning = 42 + 42
let fakers = "Fakers gonna "
let action = fakers + "fake"
let firstHalf = ["John", "Paul"]
let secondHalf = ["George", "Ringo"]
let beatles2 = firstHalf + secondHalf

// Compoud assignment operators
var quote = "The rain in Spain falls mainly on the "
quote += "Spaniards"

// Comparision Operators
"Taylor" <= "Swift"

// Switch statements
let weather = "sunny"

switch weather {
case "rain":
    print("Bring an umbrella")
case "snow":
    print("Wrap up warm")
case "sunny":
    print("Wear sunscreen")
    fallthrough
default:
    print("Enjoy your day!")
}

// Range operators
// Swift gives us two ways of making ranges: the ..< and ... operators.
// the range 1..<5 contains the numbers 1, 2, 3, and 4, whereas the range 1...5 contains the numbers 1, 2, 3, 4, and 5.
let score2 = 85

switch score2 {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
default:
    print("You did great!")
}

let names = ["Piper", "Alex", "Suzanne", "Gloria"]
print(names[0])
print(names[1...3])
print(names[1...])

// Why can’t Swift add a Double to an Int?
// In this example, we lose some accuracy
let value: Double = 90000000000000001
let value2: Int = 90000000000000001

// Why does Swift have a dedicated division remainder operator?
let weeks = 465 / 7
let days = 465 % 7
print("There are \(weeks) weeks and \(days) days until the event.")

let number = 465
let isMultiple = number.isMultiple(of: 7)

// Loops ---------------------------------------------------------------------------------------------------------------------------------------------
// For loops : it will loop over arrays and ranges
let count = 1...10
for number in count {
    print("Number is \(number)")
}

print ("Players gonna ")
for _ in 1...5 {
    print("play")
}

// While Loops
var number2 = 1
while number2 <= 20 {
    print(number2)
    number2 += 1
}
print("Ready or not, here I come!")

// Repeat Loops
var number3 = 1
repeat {
    print(number3)
    number3 += 1
} while number3 <= 20
print("Ready or not, here I come!")

let numbers2 = [1, 2, 3, 4, 5]
var random: [Int]

repeat {
    random = numbers2.shuffled()
} while random == numbers2

// Exiting Loops
var countDown = 10
while countDown >= 0 {
    print(countDown)

    if countDown == 4 {
        print("I'm bored. Let's go now!")
        break
    }

    countDown -= 1
}
print("Blast off!")

// Exiting multiple loops
outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")

        if product == 50 {
            print("It's a bullseye!")
            break outerLoop
        }
    }
}

// Skipping items
for i in 1...10 {
    if i % 2 == 1 {
        continue
    }

    print(i)
}
