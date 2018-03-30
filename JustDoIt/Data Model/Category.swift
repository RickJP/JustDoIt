//
//  Category.swift
//  JustDoIt
//
//  Created by Rick D on 2018/03/30.
//  Copyright © 2018 Firefly. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var uiColorHex : String = ""
    
    let items = List<Item>()
    
}
