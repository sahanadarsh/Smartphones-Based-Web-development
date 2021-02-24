//
//  New.swift
//  NewsTableViewXib
//
//  Created by Sahana Adarsh on 2/23/21.
//

import Foundation
import RealmSwift

class News: Object {
    @objc dynamic var author : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var descriptions : String = ""
}
