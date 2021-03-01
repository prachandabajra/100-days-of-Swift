//
//  Person.swift
//  Project10
//
//  Created by Prachanda Muni Bajracharya on 2/24/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

// NSObject is what's called a universal base class for all Cocoa Touch classes. That means all UIKit classes ultimately come from NSObject, including all of UIKit.
// Our custom class is done; it's just a simple data store for now. If you're the curious type, you might wonder why I used a class here rather than a struct. This question is even more pressing once you know that structs have an automatic initializer method made for them that looks exactly like ours. Well, the answer is: you'll have to wait and see. All will become clear in project 12!

// NSCoding is a great way to read and write data when using UserDefaults, and is the most common option when you must write Swift code that lives alongside Objective-C code.
// However, if you’re only writing Swift, the Codable protocol is much easier. We already used it to load petition JSON back in project 7, but now we’ll be loading and saving JSON.
// There are three primary differences between the two solutions:
// 1. The Codable system works on both classes and structs. We made Person a class because NSCoding only works with classes, but if you didn’t care about Objective-C compatibility you could make it a struct and use Codable instead.
// 2. When we implemented NSCoding in the previous chapter we had to write encode() and init() calls ourself. With Codable this isn’t needed unless you need more precise control - it does the work for you.
// 3. When you encode data using Codable you can save to the same format that NSCoding uses if you want, but a much more pleasant option is JSON – Codable reads and writes JSON natively.
class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
