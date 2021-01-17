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

