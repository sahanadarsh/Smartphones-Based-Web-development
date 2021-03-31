//
//  CovidData.swift
//  CovidData
//
//  Created by Sahana Adarsh on 3/30/21.
//


import Foundation
import RealmSwift

class CovidData: Object {
    @objc dynamic var state : String = ""
    @objc dynamic var total : Int64 = 0
    @objc dynamic var positive : Int64 = 0
}
