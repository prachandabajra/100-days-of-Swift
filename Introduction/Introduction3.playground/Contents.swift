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


