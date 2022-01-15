//
//  Category.swift
//  ToDoApp
//
//  Created by Karlo Fabijanić on 15.01.2022..
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
