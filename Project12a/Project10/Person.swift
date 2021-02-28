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
// We are in project 12.
// Many of Apple's own classes support NSCoding, including but not limited to: UIColor, UIImage, UIView, UILabel, UIImageView, UITableView, SKSpriteNode and many more. But your own classes do not, at least not by default. If we want to save the people array to UserDefaults we'll need to conform to the NSCoding protocol.
// It's time for the answers to become clear. You see, working with NSCoding requires you to use objects, or, in the case of strings, arrays and dictionaries, structs that are interchangeable with objects. If we made the Person class into a struct, we couldn't use it with NSCoding.
// The reason we inherit from NSObject is again because it's required to use NSCoding – although cunningly Swift won't mention that to you, your app will just crash.
// Once you conform to the NSCoding protocol, you'll get compiler errors because the protocol requires you to implement two methods: a new initializer and encode().

// First, you'll be using a new class called NSCoder. This is responsible for both encoding (writing) and decoding (reading) your data so that it can be used with UserDefaults.
// Second, the new initializer must be declared with the required keyword. This means "if anyone tries to subclass this class, they are required to implement this method." An alternative to using required is to declare that your class can never be subclassed, known as a final class, in which case you don't need required because subclassing isn't possible. We'll be using required here.

// The initializer is used when loading objects of this class, and encode() is used when saving. The code is very similar to using UserDefaults, but here we’re adding as? typecasting and nil coalescing just in case we get invalid data back.
class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}
