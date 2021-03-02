//
//  Photo.swift
//  Project10-12-Challenge
//
//  Created by Prachanda Muni Bajracharya on 3/2/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class Photo: NSObject, NSCoding {
    var name: String
    var caption: String
    
    init(name: String, caption: String) {
        self.name = name
        self.caption = caption
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(caption, forKey: "caption")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        caption = coder.decodeObject(forKey: "caption") as? String ?? ""
    }
    
}
