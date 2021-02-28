//
//  ViewController.swift
//  Project12
//
//  Created by Prachanda Muni Bajracharya on 2/27/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

// When you write data to UserDefaults, it automatically gets loaded when your app runs so that you can read it back again. This makes using it really easy, but you need to know that it's a bad idea to store lots of data in there because it will slow loading of your app. If you think your saved data would take up more than say 100KB, UserDefaults is almost certainly the wrong choice.
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        // You can also use the set() to store strings, arrays, dictionaries and dates. Now, here's a curiosity that's worth explaining briefly: in Swift, strings, arrays and dictionaries are all structs, not objects. But UserDefaults was written for NSString and friends – all of which are 100% interchangeable with Swift their equivalents – which is why this code works.
        defaults.set("Paul Hudson", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")

        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        // When you're reading values from UserDefaults you need to check the return type carefully to ensure you know what you're getting. Here's what you need to know:
        //integer(forKey:) returns an integer if the key existed, or 0 if not.
        //bool(forKey:) returns a boolean if the key existed, or false if not.
        //float(forKey:) returns a float if the key existed, or 0.0 if not.
        //double(forKey:) returns a double if the key existed, or 0.0 if not.
        //object(forKey:) returns Any? so you need to conditionally typecast it to your data type.
        
        // Knowing the return values are important, because if you use bool(forKey:) and get back "false", does that mean the key didn't exist, or did it perhaps exist and you just set it to be false?
        // It's object(forKey:) that will cause you the most bother, because you get an optional object back. You're faced with two options, one of which isn't smart so you realistically have only one option!
        // Your options:
        // Use as! to force typecast your object to the data type it should be.
        // Use as? to optionally typecast your object to the type it should be.
        // If you use as! and object(forKey:) returned nil, you'll get a crash, so I really don't recommend it unless you're absolutely sure. But equally, using as? is annoying because you then have to unwrap the optional or create a default value.
        // There is a solution here, and it has the catchy name of the nil coalescing operator, and it looks like this: ??. This does two things at once: if the object on the left is optional and exists, it gets unwrapped into a non-optional value; if it does not exist, it uses the value on the right instead.
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.bool(forKey: "UseFaceID")
        let savedArray = defaults.object(forKey:"SavedArray") as? [String] ?? [String]()
        let savedDictionary = defaults.object(forKey: "SavedDictionary") as? [String: String] ?? [String: String]()

    }


}

