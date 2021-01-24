import UIKit

// Classes and inheritance
// Classes are similar to structs but they have five important differences
// 1) The first difference between classes and structs is that classes never come with a memberwise initializer. This means if you have properties in your class, you must always create your own initializer.
class Dog {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
    
    func makeNoise() {
        print("Woof!")
    }
}
let poppy = Dog(name: "Poppy", breed: "Poodle")

// Class inheritance
// 2) The second difference between classes and structs is that you can create a class based on an existing class – it inherits all the properties and methods of the original class, and can add its own on top. This is called class inheritance or subclassing.
// For safety reasons, Swift always makes you call super.init() from child classes – just in case the parent class does some important work when it’s created.
class Poodle: Dog {
    init(name: String) {
        super.init(name: name, breed: "Poodle")
    }
}
let tom = Poodle(name: "Tom")

// Overriding methods
class Bulldog: Dog {
    override func makeNoise() {
        print("Bow!")
    }
}
let bull = Bulldog(name: "Bull", breed: "Bulldog")
bull.makeNoise()

// Final Classes
// when you declare a class as being final, no other class can inherit from it.
final class Dog2 {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

// Copying objects
// 3) The third difference between classes and structs is how they are copied. When you copy a struct, both the original and the copy are different things – changing one won’t change the other. When you copy a class, both the original and the copy point to the same thing, so changing one does change the other.
class Singer {
    var name = "Taylor Swift"
}
var singer = Singer()
print(singer.name)
var singerCopy = singer
singerCopy.name = "Justin Bieber"
print(singer.name)

struct Singer2 {
    var name = "Taylor Swift"
}
var singer2 = Singer2()
print(singer2.name)
var singer2Copy = singer2
singer2Copy.name = "Justin Bieber"
print(singer2.name)

// Deinitializers
// 4) The fourth difference between classes and structs is that classes can have deinitializers – code that gets run when an instance of a class is destroyed.
class Person {
    var name = "John Doe"

    init() {
        print("\(name) is alive!")
    }

    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    
    deinit {
        print("\(name) is no more!")
    }
}

for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}

// Mutability
// 5) The final difference between classes and structs is the way they deal with constants. If you have a constant struct with a variable property, that property can’t be changed because the struct itself is constant.
// However, if you have a constant class with a variable property, that property can be changed. Because of this, classes don’t need the mutating keyword with methods that change properties; that’s only needed with structs.
// This difference means you can change any variable property on a class even when the class is created as a constant – this is perfectly valid code:
let taylor = Singer()
taylor.name = "Ed Sheeran"
print(taylor.name)
// If you want to stop that from happening you need to make the property constant

// Why don’t Swift classes have a memberwise initializer?
// The main reason is that classes have inheritance, which would make memberwise initializers difficult to work with. Think about it: if I built a class that you inherited from, then added some properties to my class later on, your code would break – all those places you relied on my memberwise initializer would suddenly no longer work.

// Why do copies of a class share their data?
// “value types vs reference types” Structs are value types and classes are reference types
// Swift developers prefer to use structs for their custom types, and this copy behavior is a big reason.
// using a class rather than a struct sends a strong message that you want the data to be shared somehow, rather than having lots of distinct copies.

// Why do classes have deinitializers and structs don’t?
// classes have complex copying behavior that means several copies of the class can exist in various parts of your program. All the copies point to the same underlying data, and so it’s now much harder to tell when the actual class instance is destroyed – when the final variable pointing to it has gone away.
// Behind the scenes Swift performs something called automatic reference counting, or ARC. ARC tracks how many copies of each class instance exists: every time you take a copy of a class instance Swift adds 1 to its reference count, and every time a copy is destroyed Swift subtracts 1 from its reference count. When the count reaches 0 it means no one refers to the class any more, and Swift will call its deinitializer and destroy the object.
// So, the simple reason for why structs don’t have deinitializers is because they don’t need them: each struct has its own copy of its data, so nothing special needs to happen when it is destroyed.

// Why can variable properties in constant classes be changed?
// The reason for this lies in the fundamental difference between a class and a struct: one points to some data in memory, whereas the other is one value such as the number 5.
// Changing one part of a struct effectively means destroying and recreating the entire struct. Constant structs don’t allow their variable properties to be changed – it would mean destroying and recreating something that is supposed to be constant, which isn’t possible.
// Classes don’t work this way: you can change any part of their properties without having to destroy and recreate the value. As a result, constant classes can have their variable properties changed freely.

// Protocols and extensions -----------------------------------------------------------------------------------------------------------------------------
// Protocols are a way of describing what properties and methods something must have. You then tell Swift which types use that protocol – a process known as adopting or conforming to a protocol.

protocol Identifiable {
    var id: String { get set }
}

struct User: Identifiable {
    var id: String
}

func displayID(thing: Identifiable) {
    print("My ID is \(thing.id)")
}

// Protocol Inheritance
// One protocol can inherit from another in a process known as protocol inheritance. Unlike with classes, you can inherit from multiple protocols at the same time before you add your own customizations on top.
protocol Payable {
    func calculateWages() -> Int
}

protocol NeedsTraining {
    func study()
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee: Payable, NeedsTraining, HasVacation { }

// Extensions
//Extensions allow you to add methods to existing types, to make them do things they weren’t originally designed to do.
extension Int {
    func squared() -> Int {
        return self * self
    }
}

let number = 8
number.squared()

// Swift doesn’t let you add stored properties in extensions, so you must use computed properties instead.
extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

// Protocol extensions
// i) Protocols let you describe what methods something should have, but don’t provide the code inside.
// ii)Extensions let you provide the code inside your methods, but only affect one data type – you can’t add the method to lots of types at the same time.
// Protocol extensions solve both those problems: they are like regular extensions, except rather than extending a specific type like Int you extend a whole protocol so that all conforming types get your changes.
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])
// Swift’s arrays and sets both conform to a protocol called Collection
extension Collection {
    func summarize() {
        print("There are \(count) of us:")

        for name in self {
            print(name)
        }
    }
}

pythons.summarize()
beatles.summarize()

// Protocol-oriented programming
// Protocol extensions can provide default implementations for our own protocol methods. This makes it easy for types to conform to a protocol, and allows a technique called “protocol-oriented programming” – crafting your code around protocols and protocol extensions.
protocol Identifiable2 {
    var id: String { get set }
    func identify()
}

// We could make every conforming type write their own identify() method, but protocol extensions allow us to provide a default:
extension Identifiable2 {
    func identify() {
        print("My ID is \(id).")
    }
}

struct User2: Identifiable2 {
    var id: String
}

let twostraws = User2(id: "twostraws")
twostraws.identify()

// Why does Swift need protocols?
// Without using portocol:
// struct Book {
//    var name: String
// }
// func buy(_ book: Book) {
//    print("I'm buying \(book.name)")
// }
protocol Purchaseable {
    var name: String { get set }
}

struct Book: Purchaseable {
    var name: String
    var author: String
}

struct Movie: Purchaseable {
    var name: String
    var actors: [String]
}

struct Car: Purchaseable {
    var name: String
    var manufacturer: String
}

struct Coffee: Purchaseable {
    var name: String
    var strength: Int
}

func buy(_ item: Purchaseable) {
    print("I'm buying \(item.name)")
}

// When should you use extensions in Swift?
// Extensions are also useful for organizing our own code, and although there are several ways of doing this I want to focus on two here: conformance grouping and purpose grouping.
// Conformance grouping means adding a protocol conformance to a type as an extension, adding all the required methods inside that extension. This makes it easier to understand how much code a developer needs to keep in their head while reading an extension – if the current extension adds support for Printable, they won’t find printing methods mixed in with methods from other, unrelated protocols.
// On the other hand, purpose grouping means creating extensions to do specific tasks, which makes it easier to work with large types. For example, you might have an extension specifically to handle loading and saving of that type.

// When are protocol extensions useful in Swift?
// Protocol extensions are used everywhere in Swift, which is why you’ll often see it described as a “protocol-oriented programming language.” We use them to add functionality directly to protocols, which means we don’t need to copy that functionality across many structs and classes.
let numbers = [4, 8, 15, 16]
let allEven = numbers.allSatisfy { $0.isMultiple(of: 2) }

let numbers2 = Set([4, 8, 15, 16])
let allEven2 = numbers2.allSatisfy { $0.isMultiple(of: 2) }

let numbers3 = ["four": 4, "eight": 8, "fifteen": 15, "sixteen": 16]
let allEven3 = numbers3.allSatisfy { $0.value.isMultiple(of: 2) }
// Of course, the Swift developers don’t want to write this same code again and again, so they used a protocol extension: they wrote a single allSatisfy() method that works on a protocol called Sequence, which all arrays, sets, and dictionaries conform to.

// How is protocol-oriented programming different from object-oriented programming?
// Getting down to the raw facts, there is no practical difference between the two: both can place functionality into objects, use access control to limit where that functionality can be called, make one class inherit from another, and more.
// In fact, the only important difference between the two is one of mindset: POP developers lean heavily on the protocol extension functionality of Swift to build types that get a lot of their behavior from protocols. This makes it easier to share functionality across many types, which in turn lets us build bigger, more powerful software without having to write so much code.

// Optionals, unwrapping, and typecasting ----------------------------------------------------------------------------------------------------------------
// Optionals
var age: Int? = nil
age = 38

// Unwrapping optionals
var name: String? = nil

if let unwrapped = name {
    print("\(unwrapped.count) letters")
} else {
    print("Missing name.")
}

// Unwrapping with guard
// An alternative to if let is guard let, which also unwraps optionals. guard let will unwrap an optional for you, but if it finds nil inside it expects you to exit the function, loop, or condition you used it in.

// However, the major difference between if let and guard let is that your unwrapped optional remains usable after the guard code.
func greet(_ name: String?) {
    guard let unwrapped = name else {
        print("You didn't provide a name!")
        return
    }

    print("Hello, \(unwrapped)!")
}

greet(nil)

// Force unwrapping
// the crash operator
let str = "5"
//let num = Int(str)
let num = Int(str)!

// Implicitly unwrapped optionals
// Like regular optionals, implicitly unwrapped optionals might contain a value or they might be nil. However, unlike regular optionals you don’t need to unwrap them in order to use them: you can use them as if they weren’t optional at all.
// Because they behave as if they were already unwrapped, you don’t need if let or guard let to use implicitly unwrapped optionals. However, if you try to use them and they have no value – if they are nil – your code crashes.
let age2: Int! = nil

// Nil coalescing
// The nil coalescing operator unwraps an optional and returns the value inside if there is one. If there isn’t a value – if the optional was nil – then a default value is used instead.
func username(for id: Int) -> String? {
    if id == 1 {
        return "Taylor Swift"
    } else {
        return nil
    }
}

let user = username(for: 15) ?? "Anonymous"

// Optional chaining
// That question mark is optional chaining – if first returns nil then Swift won’t try to uppercase it, and will set beatle to nil immediately.
let names = ["John", "Paul", "George", "Ringo"]
let beatle = names.first?.uppercased()

// Optional try
// Back when we were talking about throwing functions, we looked at this code:
enum PasswordError: Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }

    return true
}

do {
    try checkPassword("password")
    print("That password is good!")
} catch {
    print("You can't use that password.")
}

// That runs a throwing function, using do, try, and catch to handle errors gracefully.
// There are two alternatives to try, both of which will make more sense now that you understand optionals and force unwrapping.
// The first is try?, and changes throwing functions into functions that return an optional. If the function throws an error you’ll be sent nil as the result, otherwise you’ll get the return value wrapped as an optional.
// Using try? we can run checkPassword() like this:
if let result = try? checkPassword("password") {
    print("Result was \(result)")
} else {
    print("D'oh.")
}

// The other alternative is try!, which you can use when you know for sure that the function will not fail. If the function does throw an error, your code will crash.
// Using try! we can rewrite the code to this:
try! checkPassword("sekrit")
print("OK!")

// Failable initializers
// When talking about force unwrapping, I used this code:
// let str = "5"
// let num = Int(str)
// That converts a string to an integer, but because you might try to pass any string there what you actually get back is an optional integer.
// This is a failable initializer: an initializer that might work or might not. You can write these in your own structs and classes by using init?() rather than init(), and return nil if something goes wrong. The return value will then be an optional of your type, for you to unwrap however you want.
// As an example, we could code a Person struct that must be created using a nine-letter ID string. If anything other than a nine-letter string is used we’ll return nil, otherwise we’ll continue as normal.
struct Person2 {
    var id: String

    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}
var person2 = Person2(id: "fdfkjd")

// Typecasting
class Animal { }
class Fish: Animal { }

class Dog3: Animal {
    func makeNoise() {
        print("Woof!")
    }
}

let pets = [Fish(), Dog3(), Fish(), Dog3()]

for pet in pets {
    if let dog = pet as? Dog3 {
        dog.makeNoise()
    }
}


// Why does Swift make us unwrap optionals?
// The single most important feature of optionals is that Swift won’t let us use them without unwrapping them first. This provides a huge amount of protection for all our apps, because it puts a stop to uncertainty: when you’re handing a string you know it’s a valid string, when you call a function that returns an integer, you know it’s immediately safe to use. And when you do have optionals in your code, Swift will always make sure you handle them correctly – that you check and unwrap them, rather than just mixing unsafe values with known safe data.

// When to use "guard let" rather than "if let"?
// It’s common to see guard used one or more times at the start of methods, because it’s used to verify conditions are correct up front. This makes our code easier to read than if we tried to check a condition then run some code, then check another condition and run some different code.
// So, use if let if you just want to unwrap some optionals, but prefer guard let if you’re specifically checking that conditions are correct before continuing.

// When should you force unwrap optionals in Swift?
// So, I think force unwrapping is sometimes a good idea, and sometimes even required. However, I am not advocating that you start scattering exclamation marks around your program, because that starts to get messy.
// Instead, a better idea is to create a handful of functions and extensions that isolate your force unwraps in one place. This means your force unwrapping can be stored near to the place where its behavior is clarified, and the vast majority of your code doesn’t need to force unwrap directly.
enum Direction: CaseIterable {
    case north, south, east, west

    static func random() -> Direction {
        Direction.allCases.randomElement()!
    }
}
// With that in place, everywhere we need to get a random direction no longer needs a force unwrap:
let randomDirection = Direction.random()

// Why does Swift need both implicitly unwrapped optionals and regular optionals?
// In the earlier days of Swift, implicitly unwrapped optionals (IUOs) played a critical part in making our code work. However, since SwiftUI launched they are disappearing by the thousand. That’s not to say they are useless, only that they are becoming much more rare.
// The primary reason for IUOs is for use with Apple’s older UIKit user interface framework. If you wanted an image in your layout you’d need to create a property for it, but that image wouldn’t be created immediately – UIKit has a performance optimization that means the image is only created when that piece of user interface is actually shown. Apple pushes back the work of creating the image until it’s actually needed, like a lazy Swift property, but in practice it means the variable starts as nil then gets set to an image as soon as it’s needed, at which point we can start using it.

// When should you use nil coalescing in Swift?
// Nil coalescing lets us attempt to unwrap an optional, but provide a default value if the optional contains nil. This is extraordinarily useful in Swift, because although optionals are a great feature it’s usually better to have a non-optional – to have a real string rather than a “might be a string, might be nil” – and nil coalescing is a great way to get that.

// Why is optional chaining so important?
// Optional chaining makes for a very good companion to nil coalescing, because it allows you to dig through layers of optionals while also providing a sensible fall back if any of the optionals are nil.
let names2 = ["Vincent": "van Gogh", "Pablo": "Picasso", "Claude": "Monet"]
let surnameLetter = names2["Vincent"]?.first?.uppercased() ?? "?"

// When should you use optional try?
// There are advantages and disadvantages to using optional try, but it mostly centers around how important the error is to you. If you want to run a function and care only that it succeeds or fails – you don’t need to distinguish between the various reasons why it might fail – then using optional try is a great fit, because you can boil the whole thing down to “did it work?”

// Why would you want a failable initializer?
struct Employee2 {
    var username: String
    var password: String

    init?(username: String, password: String) {
        guard password.count >= 8 else { return nil }
        guard password.lowercased() != "password" else { return nil }

        self.username = username
        self.password = password
    }
}

let tim = Employee2(username: "TimC", password: "app1e")
let craig = Employee2(username: "CraigF", password: "ha1rf0rce0ne")
// Failable initializers give us the opportunity to back out of an object’s creation if validation checks fail. In the previous case that was a password that was too short, but you could also check whether the username was taken already, whether the password was the same as the username, and so on.
// Yes, you could absolutely put these checks into a separate method, but it’s much safer to put them into the initializer – it’s too easy to forget to call the other method, and there’s no point leaving that hole open.


