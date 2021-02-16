//
//  TableViewController.swift
//  TableViewXib
//
//  Created by Sahana Adarsh on 2/15/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cities = ["Seattle", "Portland", "Renton", "Kirkland", "Bothell", "Redmond", "MillCreek","Mysore","Bangalore","SFO","Freemont","Sunnyvale","Everett"]
    
    //temperature in celsius
    let temperatures = ["4", "3", "6", "5", "1", "3", "2", "23", "28", "12", "11", "15", "5"];

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblCity.text = cities[indexPath.row]
        cell.lblTemperature.text = temperatures[indexPath.row] + "°C"

        // Configure the cell...

        return cell
    }

}
