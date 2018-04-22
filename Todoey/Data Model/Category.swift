//
//  Category.swift
//  Todoey
//
//  Created by Pankaj Kumar on 22/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //Defining A Forward Relationship i.e one to Many
    let items = List<Item>()
}
