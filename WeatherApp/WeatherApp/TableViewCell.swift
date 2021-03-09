//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Sahana Adarsh on 3/9/21.
//

import UIKit

class TableViewCell: UITableViewCell {
        
    @IBOutlet weak var lblDay: UILabel!
        
    @IBOutlet weak var lblMax: UILabel!
    
    @IBOutlet weak var lblMin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
