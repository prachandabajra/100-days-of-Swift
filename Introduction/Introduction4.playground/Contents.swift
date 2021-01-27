import UIKit

// Swift review: Optionals
func getHaterStatus(weather: String) -> String? {
    if weather == "sunny" {
        return nil
    } else {
        return "Hate"
    }
}

// we need to make the status variable a String?, or just remove the type annotation entirely and let Swift use type inference.
var status: String?
status = getHaterStatus(weather: "rainy")

var status2 = getHaterStatus(weather: "rainy")

func takeHaterAction(status: String) {
    if status == "Hate" {
        print("Hating")
    }
}

if let haterStatus = getHaterStatus(weather: "rainy") {
    takeHaterAction(status: haterStatus)
}

// Implicitly unwrapped optionals
// An implicitly unwrapped optional might contain a value, or might not. But it does not need to be unwrapped before it is used. Swift won't check for you, so you need to be extra careful. Example: String! might contain a string, or it might contain nil – and it's down to you to use it appropriately. It’s like a regular optional, but Swift lets you access the value directly without the unwrapping safety. If you try to do it, it means you know there’s a value there – but if you’re wrong your app will crash.
// The main times you're going to meet implicitly unwrapped optionals is when you're working with user interface elements in UIKit on iOS or AppKit on macOS. These need to be declared up front, but you can't use them until they have been created – and Apple likes to create user interface elements at the last possible moment to avoid any unnecessary work. Having to continually unwrap values you definitely know will be there is annoying, so these are made implicitly unwrapped.

// Optional chaining and nil coalescing operator
func albumReleased(year: Int) -> String? {
    switch year {
    case 2006: return "Taylor Swift"
    case 2008: return "Fearless"
    case 2010: return "Speak Now"
    case 2012: return "Red"
    case 2014: return "1989"
    default: return nil
    }
}

let album = albumReleased(year: 2006)
print("The album is \(album)")
let album2 = albumReleased(year: 2006) ?? "unknown"
print("The album is \(album2)")


// Enumerations
enum WeatherType {
    case sun, cloud, rain, wind, snow
}

func getHaterStatus(weather: WeatherType) -> String? {
    if weather == WeatherType.sun {
        return nil
    } else {
        return "Hate"
    }
}

getHaterStatus(weather: WeatherType.cloud)

// OR
enum WeatherType2 {
    case sun
    case cloud
    case rain
    case wind
    case snow
}

func getHaterStatus2(weather: WeatherType2) -> String? {
    if weather == .sun {
        return nil
    } else {
        return "Hate"
    }
}

getHaterStatus2(weather: .cloud)

// OR
func getHaterStatus3(weather: WeatherType) -> String? {
    switch weather {
    case .sun:
        return nil
    case .cloud, .wind:
        return "dislike"
    case .rain:
        return "hate"
    case .snow:
        return ""
    }
}

// Enums with additional values
enum WeatherType4 {
    case sun
    case cloud
    case rain
    case wind(speed: Int)
    case snow
}

func getHaterStatus4(weather: WeatherType4) -> String? {
    switch weather {
    case .sun:
        return nil
    case .wind(let speed) where speed < 10:
        return "meh"
    case .cloud, .wind:
        return "dislike"
    case .rain, .snow:
        return "hate"
    }
}

getHaterStatus4(weather: WeatherType4.wind(speed: 5))

//Working with Objective-C code
//If you want to have some part of Apple’s operating system call your Swift class’s method, you need to mark it with a special attribute: @objc. This is short for “Objective-C”, and the attribute effectively marks the method as being available for older Objective-C code to run – which is almost all of iOS, macOS, watchOS, and tvOS. For example, if you ask the system to call your method after one second has passed, you’ll need to mark it with @objc.
//Don’t worry too much about @objc for now – not only will I be explaining it in context later on, but Xcode will always tell you when it’s needed. Alternatively, if you don’t want to use @objc for individual methods you can put @objcMembers before your class to automatically make all its methods available to Objective-C.

// Swift Review 3
// Properties
// Property Observers
struct Person {
    var clothes: String {
        willSet {
            updateUI(msg: "I'm changing from \(clothes) to \(newValue)")
        }

        didSet {
            updateUI(msg: "I just changed from \(oldValue) to \(clothes)")
        }
    }
}

func updateUI(msg: String) {
    print(msg)
}

var taylor = Person(clothes: "T-shirts")
taylor.clothes = "short skirts"

// Computed properties
// To make a computed property, place an open brace after your property then use either get or set to make an action happen at the appropriate time.
struct Person2 {
    var age: Int

    var ageInDogYears: Int {
        get {
            return age * 7
        }
    }
}

var fan = Person2(age: 25)
print(fan.ageInDogYears)

// Note: If you intend to use them only for reading data you can just remove the get part entirely, like this:
//var ageInDogYears: Int {
//    return age * 7
//}

// Access control
// Access control lets you specify what data inside structs and classes should be exposed to the outside world, and you get to choose four modifiers:
// Public: this means everyone can read and write the property.
// Internal: this means only your Swift code can read and write the property. If you ship your code as a framework for others to use, they won’t be able to read the property.
// File Private: this means that only Swift code in the same file as the type can read and write the property.
// Private: this is the most restrictive option, and means the property is available only inside methods that belong to the type, or its extensions.

// Polymorphism and typecasting
class Album {
    var name: String

    init(name: String) {
        self.name = name
    }

    func getPerformance() -> String {
        return "The album \(name) sold lots"
    }
}

class StudioAlbum: Album {
    var studio: String

    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }

    override func getPerformance() -> String {
        return "The studio album \(name) sold lots"
    }
}

class LiveAlbum: Album {
    var location: String

    init(name: String, location: String) {
        self.location = location
        super.init(name: name)
    }

    override func getPerformance() -> String {
        return "The live album \(name) sold lots"
    }
}

var taylorSwift = StudioAlbum(name: "Taylor Swift", studio: "The Castles Studios")
var fearless = StudioAlbum(name: "Speak Now", studio: "Aimeeland Studio")
var iTunesLive = LiveAlbum(name: "iTunes Live from SoHo", location: "New York")

var allAlbums: [Album] = [taylorSwift, fearless, iTunesLive]

// Typecasting in Swift comes in three forms, but most of the time you'll only meet two: as? and as!, known as optional downcasting and forced downcasting.
for album in allAlbums {
    print(album.getPerformance())
    
    if let studioAlbum = album as? StudioAlbum {
        print(studioAlbum.studio)
    } else if let liveAlbum = album as? LiveAlbum {
        print(liveAlbum.location)
    }
}

// Swift also allows optional downcasting at the array level, although it's a bit more tricksy because you need to use the nil coalescing operator to ensure there's always a value for the loop. Here's an example:
for album in allAlbums as? [LiveAlbum] ?? [LiveAlbum]() {
    print(album.location)
}

// Converting common types with initializers
let number = 5
let text = String(number)
print(text)
