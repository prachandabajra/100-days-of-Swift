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


