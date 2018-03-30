//
//  Item.swift
//  JustDoIt
//
//  Created by Rick D on 2018/03/30.
//  Copyright © 2018 Firefly. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
