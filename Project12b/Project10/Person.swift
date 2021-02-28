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
class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
