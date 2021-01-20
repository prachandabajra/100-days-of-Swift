import UIKit

// Functions --------------------------------------------------------------------------------------------------------------------------------------------
func printHelp() {
    let message = """
Welcome to MyApp!

Run this app inside a directory of images and MyApp will resize them all into thumbnails
"""
    print(message)
}
printHelp()

// Accepting parameters and returning parameters
// If you need to return multiple values, this is a perfect example of when to use tuples.
func square(number: Int) -> Int {
    return number * number
}
let result = square(number: 8)
print(result)

// Parameter labels
func sayHello(to name: String) {
    print("Hello, \(name)!")
}
sayHello(to: "Taylor")

// Omitting parameter labels
func greet(_ person: String) {
    print("Hello, \(person)!")
}
greet("Taylor")

// Default parameters
// print() has a "terminator" parameter that uses new line as its default value.
func greet2(_ person: String, nicely: Bool = true) {
    if nicely == true {
        print("Hello, \(person)!")
    } else {
        print("Oh no, it's \(person) again...")
    }
}
greet2("Taylor")
greet2("Taylor", nicely: false)

// Variadic functions -  they accept any number of parameters of the same type.
// You can make any parameter variadic by writing ... after its type.
// Swift converts the values that were passed in to an array of integers,
print("Haters", "gonna", "hate")

func square2(numbers: Int...) {
    for number in numbers {
        print("\(number) squared is \(number * number)")
    }
}
square2(numbers: 1, 2, 3, 4, 5)

// Writing throwing functions
enum PasswordError: Error {
    case obvious
}
func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    
    return true
}

// Running throwing functions
do {
    try checkPassword("password")
    print("That password is good!")
} catch {
    print("You can't use that password.")
}

// inout paramters
// You can use inout to change variables inside a function, but it’s usually better to return a new value.
func doubleInPlace(number: inout Int) {
    number *= 2
}

var myNum = 10
doubleInPlace(number: &myNum)

// When is the return keyword not needed in a Swift function?
// We use the return keyword to send back values from functions in Swift, but there is one specific case where it isn’t needed: when our function contains only a single expression.
func greet3(name: String) -> String {
    name == "Taylor Swift" ? "Oh wow!" : "Hello, \(name)"
}
greet3(name: "Taylor Swift")

// How can you return two or more values from a function?
// i) Using a tuple, such as (name: String, age: Int)
// ii) Using some sort of collection, such as an array or a dictionary.
func getUser() -> (first: String, last: String) {
    (first: "Taylor", last: "Swift")
}

let user = getUser()
print(user.first)

// When should you write throwing functions?
// When you’re learning start small: keep the number of throwing functions low, and work outwards from there. Over time you’ll get a get better grip on managing errors to keep your program flow smooth, and you’ll feel more confident about adding throwing functions.

// Why does Swift make us use try before every throwing function?
// The reason Swift is different is fairly simple: by forcing us to use try before every throwing function, we’re explicitly acknowledging which parts of our code can cause errors. This is particularly useful if you have several throwing functions in a single do block, like this:

// When should you use inout parameters?
// How common are they? Well, all of Swift’s operators are actually implemented as functions behind the scenes – things like +, -, and so on. Yes, they really are just functions behind the scenes. You can imagine them a bit like this:
// func +(leftNumber: Int, rightNumber: Int) -> Int {
    // code here
// }
// Now think about the += operator, which both adds and assigns at the same time. That doesn’t have a return value, but actually modifies the original value directly.
// func +=(leftNumber: inout Int, rightNumber: Int) {
    // code here
// }
// it’s best to avoid creating inout parameters until you feel confident they are definitely the right choice.

// Closures ------------------------------------------------------------------------------------------------------------------------------------------------
// Creating basic closures
let driving = {
    print("I'm driving in my car")
}
driving()

// Accepting parameters in closures
// - One of the differences between functions and closures is that you don’t use parameter labels when running closures.
// Returning values from a closure
let driving2 = { (place: String) -> String in
    return "I'm going to \(place) in my car."
}
let message = driving2("London")
print(message)

// Closures as parameters
func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}
travel(action: driving)

// Trailing closure syntax
// If the last parameter to a function is a closure, Swift lets you use special syntax called trailing closure syntax. Rather than pass in your closure as a parameter, you pass it directly after the function inside braces.
travel() {
    print("Trailing closure")
}
// because there aren’t any other parameters, we can eliminate the parentheses entirely
travel {
    print("Trailing closure2")
}

// Using closures as parameters when they accept parameters
func travel2(action: (String) -> Void) {
    print("I'm getting ready to go.")
    action("London")
    print("I arrived!")
}
travel2 { (place: String) in
    print("I'm going to \(place) in my car")
}

// Using closures as parameters when they return values
func travel3(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}
travel3 { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

// Shorthand parameter names
// - Swift knows the parameter to that closure must be a string, so we can remove it
travel3 { place -> String in
    return "I'm going to \(place) in my car"
}
// It also knows the closure must return a string, so we can remove that:
travel3 { place in
    return "I'm going to \(place) in my car"
}
// As the closure only has one line of code that must be the one that returns the value, so Swift lets us remove the return keyword too:
travel3 { place in
    "I'm going to \(place) in my car"
}
// Rather than writing place in we can let Swift provide automatic names for the closure’s parameters. These are named with a dollar sign, then a number counting from 0.
travel3 {
    "I'm going to \($0) in my car"
}

// Closures with multiple parameters
func travel4(action: (String, Int) -> String) {
    print("I'm getting ready to go.")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}
travel4 {
    "I'm going to \($0) at \($1) miles per hour."
}

// Returning closures from functions
func travel5() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
let result2 = travel5()
result2("London")
// It’s technically allowable – although really not recommended! – to call the return value from travel() directly:
travel5()("London")

// Capturing values
// If you use any external values inside your closure, Swift captures them – stores them alongside the closure, so they can be modified even if they don’t exist any more.
func travel6() -> (String) -> Void {
    var counter = 1

    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}
let result3 = travel6()
result3("London")
result3("London")
result3("London")
result3("London")

// When would you use closures with return values as parameters to a function?
func reduce(_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
    // start with a total equal to the first value
    var current = values[0]

    // loop over all the values in the array, counting from index 1 onwards
    for value in values[1...] {
        // call our closure with the current value and the array element, assigning its result to our current value
        current = closure(current, value)
    }

    // send back the final current value
    return current
}

// - With that code in place, we can now write this so add up an array of numbers:
let numbers = [10, 20, 30]

let sum = reduce(numbers) { (runningTotal: Int, next: Int) in
    runningTotal + next
}

print(sum)

// - I mentioned previously that Swift’s operators are actually functions in their own right. For example, + is a function that accepts two numbers (e.g. 5 and 10) and returns another number (15). As a result, we can actually write this:
let sum2 = reduce(numbers, using: +)
// Third, this reduce() function is so important that a variant actually comes with Swift as standard. The concept is the same, but it’s more advanced in several ways

// Structs, properties and methods -------------------------------------------------------------------------------------------------------------------------------
// That has a name property that stores a String. These are called "stored properties", because Swift has a different kind of property called a "computed property" – a property that runs code to figure out its value.
struct Sport {
    var name: String
    var isOlympicSport: Bool

    var olympicStatus: String {
        if isOlympicSport {
            return "\(name) is an Olympic sport"
        } else {
            return "\(name) is not an Olympic sport"
        }
    }
}
var tennis = Sport(name: "Tennis", isOlympicSport: true)
print(tennis.name)
tennis.name = "Lawn tennis"

let chessBoxing = Sport(name: "Chessboxing", isOlympicSport: false)
print(chessBoxing.olympicStatus)

// Property observers
// Property observers let you run code before or after any property changes.
// didSet, willSet
// You can also use willSet to take action before a property changes, but that is rarely used.
struct Progress {
    var task: String
    var amount: Int {
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}

var progress = Progress(task: "Loading data", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100

// Methods
struct City {
    var population: Int

    func collectTaxes() -> Int {
        return population * 1000
    }
}

let london = City(population: 9_000_000)
london.collectTaxes()

// Mutating methods
// Swift won’t let you write methods that change properties unless you specifically request it.
struct Person {
    var name: String

    mutating func makeAnonymous() {
        name = "Anonymous"
    }
}

var person = Person(name: "Ed")
person.makeAnonymous()

// Properties and methods of strings
// Strings are structs
let string = "Do or do not, there is no try."
print(string.count)
print(string.hasPrefix("Do"))
print(string.uppercased())
print(string.sorted())

// Properties and methods of arrays
var toys = ["Woody"]
print(toys.count)
toys.append("Buzz")
toys.firstIndex(of: "Buzz")
print(toys.sorted())
toys.remove(at: 0)

// What’s the difference between a struct and a tuple?
// use tuples when you want to return two or more arbitrary pieces of values from a function, but prefer structs when you have some fixed data you want to send or receive multiple times.

// When should you use willSet rather than didSet?
// For example, SwiftUI uses willSet in some places to handle animations so that it can take a snapshot of the user interface before a change. When it has both the “before” and “after” snapshot, it can compare the two to see all the parts of the user interface that need to be updated.

// Why do strings behave differently from arrays in Swift?
// Swift lets us read array values using myArray[3], we can’t do the same with strings – myString[3] is invalid.
// Note: if you want to check whether a string is empty, you should write this: 'myString.isEmpty' instead of 'myString.count == 0'
// second one is slow

// Access control, static properties and laziness ---------------------------------------------------------------------------------------------------------
// Initializers
// Initializers are special methods that provide different ways to create your struct. All structs come with one by default, called their memberwise initializer – this asks you to provide a value for each property when you create the struct.
struct User {
    var username: String

    init() {
        username = "Anonymous"
        print("Creating a new user!")
    }
}
var user2 = User()
user2.username = "twostraws"

// Self
struct Person2 {
    var name: String

    init(name: String) {
        print("\(name) was born!")
        self.name = name
    }
}

// Lazy properties
struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}

struct Person3 {
    var name: String
    lazy var familyTree = FamilyTree()

    init(name: String) {
        self.name = name
    }
}

var ed = Person3(name: "Ed")
ed.familyTree

// Static properties and methods
struct Student {
    static var classSize = 0
    var name: String

    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}

let ed2 = Student(name: "Ed")
let taylor = Student(name: "Taylor")
print(Student.classSize)

// Access control
// Access control lets you restrict which code can use properties and methods
// Keywords: private, public
struct Person4 {
    private var id: String

    init(id: String) {
        self.id = id
    }
    
    func identify() -> String {
           return "My social security number is \(id)"
       }
}
let ed3 = Person4(id: "12345")
print(ed3.identify())

// How do Swift’s memberwise initializers work?
struct Employee {
    var name: String
    var yearsActive = 0
}

let roslin = Employee(name: "Laura Roslin")
let adama = Employee(name: "William Adama", yearsActive: 45)

// The second clever thing Swift does is remove the memberwise initializer if you create an initializer of your own.
// So, as soon as you add a custom initializer for your struct, the default memberwise initializer goes away. If you want it to stay, move your custom initializer to an extension, like this:
struct Employee2 {
    var name: String
    var yearsActive = 0
}

extension Employee2 {
    init() {
        self.name = "Anonymous"
        print("Creating an anonymous employee…")
    }
}

// creating a named employee now works
let roslin2 = Employee2(name: "Laura Roslin")

// as does creating an anonymous employee
let anon = Employee2()

// When should properties be lazy?
// There are a few reasons why you would prefer stored or computed properties over a lazy property, such as:
// i) Using lazy properties can accidentally produce work where you don’t expect it. For example, if you’re building a game and access a complex lazy property for the first time it might cause your game to slow down, so it’s much better to do slow work up front and get it out of the way.
// ii) Lazy properties always store their result, which might either be unnecessary (because you aren’t use it again) or be pointless (because it needs to be recalculated frequently).
// iii) Because lazy properties change the underlying object they are attached to, you can’t use them on constant structs.

