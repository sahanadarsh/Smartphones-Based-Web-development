//
//  TableViewCell.swift
//  CovidData
//
//  Created by Sahana Adarsh on 3/30/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var lblState: UILabel!
    
    @IBOutlet var lblPositive: UILabel!
    
    @IBOutlet var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
