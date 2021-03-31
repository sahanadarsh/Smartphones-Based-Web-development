//
//  TableViewController.swift
//  CovidData
//
//  Created by Sahana Adarsh on 3/30/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import PromiseKit

class TableViewController: UITableViewController {
    
    var covidDataArr: [CovidData] = [CovidData]()
    
    @IBOutlet var tblCovidData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCovidData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covidDataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblState.text = "\(covidDataArr[indexPath.row].state) "
        cell.lblTotal.text = "\(covidDataArr[indexPath.row].total) "
        cell.lblPositive.text = "\(covidDataArr[indexPath.row].positive) "
        
        return cell
    }
    
    func getUrl() -> String{
        let url = apiURL
        return url
    }
    
    func getCovidData(){
        let url = getUrl()
        getData(url)
            .done { (datas) in
                self.covidDataArr = [CovidData]()
                print(datas)
                for data in datas {
                    self.covidDataArr.append(data)
                }
                self.tblCovidData.reloadData()
            }
            .catch { (error) in
                print("Error in getting all the covid data \(error)")
            }
    }
    
    func getData(_ url : String) -> Promise<[CovidData]>{
        return Promise<[CovidData]> { seal -> Void in
            SwiftSpinner.show("Getting Covid Data")
            AF.request(url).responseJSON { response in
                SwiftSpinner.hide()
                
                if response.error == nil {
                    
                    var arr  = [CovidData]()
                    guard let data = response.data else {return seal.fulfill( arr ) }
                    guard let datas = JSON(data).array else {return  seal.fulfill( arr )}
                    
                    for data in datas {
                        
                        let state = data["state"].stringValue
                        let total = data["total"].intValue
                        let positive = data["positive"].intValue
                        
                        let data = CovidData()
                        data.state = state
                        data.total = Int64(total)
                        data.positive = Int64(positive)
                        arr.append(data)
                        
                    }
                    seal.fulfill(arr)
                }
                else {
                    seal.reject(response.error!)
                }
            }
        }
    }
    
}
