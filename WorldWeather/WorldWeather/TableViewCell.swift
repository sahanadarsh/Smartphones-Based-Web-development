//
//  TableViewCell.swift
//  WorldWeather
//
//  Created by Sahana Adarsh on 3/15/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var lblDay: UILabel!
        
    @IBOutlet var dayImg: UIImageView!
    
    @IBOutlet var lblMax: UILabel!
    
    @IBOutlet var nightImg: UIImageView!
    
    @IBOutlet var lblMin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
