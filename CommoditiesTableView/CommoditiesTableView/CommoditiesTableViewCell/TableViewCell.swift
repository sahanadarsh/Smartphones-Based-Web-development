//
//  TableViewCell.swift
//  CommoditiesTableView
//
//  Created by Sahana Adarsh on 3/2/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
