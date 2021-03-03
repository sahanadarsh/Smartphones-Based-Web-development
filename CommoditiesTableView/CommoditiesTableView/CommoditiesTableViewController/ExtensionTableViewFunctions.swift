//
//  ExtensionTableViewFunctions.swift
//  CommoditiesTableView
//
//  Created by Sahana Adarsh on 3/2/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commodityArr.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblName.text = "\(commodityArr[indexPath.row].name) "
        
        cell.lblPrice.text = "$\(commodityArr[indexPath.row].price)"
        
        return cell
    }
    
}
