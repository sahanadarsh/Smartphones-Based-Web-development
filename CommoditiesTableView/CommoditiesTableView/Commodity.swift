//
//  Commodity.swift
//  CommoditiesTableView
//
//  Created by Sahana Adarsh on 3/2/21.
//

import Foundation
import RealmSwift

class Commodity: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var price : Float = 0.0

}
