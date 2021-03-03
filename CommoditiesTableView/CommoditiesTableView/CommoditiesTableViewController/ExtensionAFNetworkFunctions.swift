//
//  ExtensionAFNetworkFunctions.swift
//  CommoditiesTableView
//
//  Created by Sahana Adarsh on 3/2/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import PromiseKit

extension TableViewController{
    
    func getUrl() -> String{
        
        var url = apiURL
        
        url.append(apiKey)
        
        return url
        
    }
    
    func getData(){
        
        let url = getUrl()
        
        getQuickShortQuote(url)
            
            .done { (commodities) in
                
                self.commodityArr = [Commodity]()
                
                for commodity in commodities {
                    self.commodityArr.append(commodity)
                }
                
                self.tblCommodities.reloadData()
                
            }
            .catch { (error) in
                
                print("Error in getting all the commodities values \(error)")
                
            }
        
    }
    
    @objc func getCommodityData(){
        
        getData()
        
        self.refreshControl?.endRefreshing()
        
    }
    
    
    func getQuickShortQuote(_ url : String) -> Promise<[Commodity]>{
        
        return Promise<[Commodity]> { seal -> Void in
            
            SwiftSpinner.show("Getting Commodities Price")
            
            AF.request(url).responseJSON { response in
                
                SwiftSpinner.hide()
                
                if response.error == nil {
                    
                    var arr  = [Commodity]()
                    
                    guard let data = response.data else {return seal.fulfill( arr ) }
                    
                    guard let commodities = JSON(data).array else {return  seal.fulfill( arr )}
                    
                    for commodity in commodities {
                        
                        let name = commodity["name"].stringValue
                        let price = commodity["price"].floatValue
                        
                        let commodity = Commodity()
                        commodity.name = name
                        commodity.price = price
                        arr.append(commodity)
                        
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
