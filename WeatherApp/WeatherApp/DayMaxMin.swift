//
//  DayMaxMin.swift
//  WeatherApp
//
//  Created by Sahana Adarsh on 3/9/21.
//

import Foundation
import RealmSwift

class DayMaxMin: Object {
    @objc dynamic var day : String = ""
    @objc dynamic var max : Int = 0
    @objc dynamic var min : Int = 0
}
