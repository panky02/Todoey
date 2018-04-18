//
//  Item.swift
//  Todoey
//
//  Created by Pankaj Kumar on 18/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import Foundation

//class Item : Encodable, Decodable {
// OR below from Swift4 onwards
class Item : Codable {
    var title:String = ""
    var done:Bool = false
}
