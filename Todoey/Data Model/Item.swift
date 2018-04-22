//
//  Item.swift
//  Todoey
//
//  Created by Pankaj Kumar on 22/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated: Date? = nil
    //defining a backward relationship i.e many to one
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
