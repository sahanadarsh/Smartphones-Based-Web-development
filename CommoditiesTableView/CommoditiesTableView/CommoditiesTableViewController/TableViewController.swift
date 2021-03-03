//
//  TableViewController.swift
//  CommoditiesTableView
//
//  Created by Sahana Adarsh on 3/2/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift

class TableViewController: UITableViewController {
    
    var nameArr: [String] = [String]()
    
    var commodityArr: [Commodity] = [Commodity]()
    
    @IBOutlet var tblCommodities: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCommodityData()
    }
    
}
