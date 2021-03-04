import UIKit

// Function programming
// map()
func lengthOf(strings: [String]) -> [Int] {
    return strings.map { $0.count }
}

let strLength = lengthOf(strings: ["John", "Hello"])
print(strLength)

let strings = ["am", "stram", "gram"]
let result = strings.map { $0.uppercased() }
print(result)

// flatmap() - Compact map
// after map it will unwrap your optionals and throw away any nils
let input = ["1", "5", "Fish"]
let numbers = input.compactMap { Int($0) }
print(numbers)

// map() and compactMap() with Optionals
// In map(), if input is optional, output is also optional

//let name: String? = getUser(id: 97)
//let greet = name.map { "Hi, \($0)!"}
//print(greet ?? "Unknown user")

// map(): if input is optional and map's procession part also returns optional then output is Optional(Optional) i.e Int??
// To solve this issue we use flatmap()
let number1: String? = "5"
let result1 = number1.map { Int($0) }
print(result1)

let number2: String? = "5"
let result2 = number2.flatMap { Int($0) }
print(result2)

// filter
//let goodWine = wine.filter {
//    $0.origin == "France"
//}

// Other functional: first()
//let firstHigh = score.first { $0 > 85

let ints = [9,5,3,5]
let counts = ints.map { ($0, 1) } // [(9,1),(5,1),(3,1),(5,1)]
let dict = Dictionary(counts, uniquingKeysWith: +)

let numbers1 = Array(1...100)
let sum = numbers1.reduce(0, +)

//https://vimeo.com/291590798
/*
 SYSTEM PROBLEMS
User Defaults, keychain,
Timers: strong reference(Memory leaks), invalidate, tolerance, Libraries:….
timer Precesion, CADisplayLink
let link = CADisplayLink(target: self, selector: #selector(update))
link.add(to: .current, forMode: .commonModes)

Attributed Strings: Use wrappers- Attributed, BOString, BonMot…
Concurrency: To delay a code don’t use DispatchQueue.main.asyncAfter(deacline:.now ….
Use perform()
perform(#selector(log), with: “parameter”, afterDelay: 1)
 
 func fibonacci(of num: Int) ->Int{}
 var array = Array(0..<42)
 DispatchQueue.concurrentPerform(iterations: array.count){
    array[$0] = fibonaci(of: $0)
 }
 
 UI PROBLEMS
 4. Videos
 ios sdk play movie
 Don't use: MPMoviePlayerController
 Use: AVPlayerViewController
 
 3. Image Views
 load remote image into image views
 Use libraries: SDWebImage, RemoteImageView, AlomofireImage, PINRemoteImage, Imaginary
 
 2. Web Views
 WKWebView
 
 1. Auto Layout
 AutoLayout wrapper: But still has problems
 
 SWIFT PROBLEMS
 2. Strings
 Use StaticStrings
 URL(string:), UIImage(named:), UIColor(named:), NSRegularExpression(pattern:)
 
 extension UIImage {
    convenience init(bundleName: StaticString) {
        self.init(named: "\(bundleName)")!
    }
 }
 Here we can use force unwrap because of StaticString
 
 1. Optionals
 let name: String! = "Han Solo"
 let characterName = name
// characterName is String?
 So don't return optionals, return hard strings
 
 enum PasswordError: Error {
    case obvious
 }
 func encrypt(key: String) throws -> String {
    if key == "12345" {
        print("I have the same key on my luggage.")
        throw PasswordError.obvious
    }
    return"Encryption complete
 }
 
 user?.name?.uppercased() ?? "Anonymous"
 
 Use functional programming: compactMap()
 
 Warning and error directive: #warning() #error()
 */

