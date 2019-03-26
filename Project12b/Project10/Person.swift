//
//  Person.swift
//  Project10
//
//  Created by Josue Quiñones on 3/16/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
