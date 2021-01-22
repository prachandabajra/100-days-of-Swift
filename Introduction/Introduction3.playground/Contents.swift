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

