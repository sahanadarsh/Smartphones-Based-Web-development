//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sahana Adarsh on 3/8/21.
//
//test

import UIKit
import CoreLocation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import PromiseKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var dayMaxMinArr: [DayMaxMin] = [DayMaxMin]()
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
    
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var lblHighLow: UILabel!
    
    @IBOutlet var tblDayMaxMin: UITableView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayMaxMinArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblDay.text = "\(dayMaxMinArr[indexPath.row].day) "
        cell.lblMax.text = "\(dayMaxMinArr[indexPath.row].max)°F "
        cell.lblMin.text = "\(dayMaxMinArr[indexPath.row].min)°F "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let currLocation = locations.last{
            let lat = currLocation.coordinate.latitude
            let lng = currLocation.coordinate.longitude
            
            self.updateLocalWeather(lat, lng)
        }
    }
    
}

//MARK: Updating weather Ccondition
extension ViewController{
    
    func updateLocalWeather(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees){
        
        let url = getLocationURL(lat, lng)
        
        getLocationData(url)
            .done { (key,city) in
                
                self.lblCity.text = city
                
                let currentConditionURL = self.getCurrentConditionURL(key)
                
                self.updateWeatherData(currentConditionURL)
                    .done { (currCondition, temp) in
                        self.lblCondition.text = currCondition
                        self.lblTemp.text = "\(String(temp))°F"
                    }
                    .catch{ error in
                        print("Error in getting current condition \(error.localizedDescription)")
                    }
                
                let oneDayURL = self.getOneDayURL(key)
                
                self.getOneDayConditions(oneDayURL)
                    .done { (low, high) in
                        self.lblHighLow.text = "H:\(high)°F L:\(low)°F"
                    }
                    .catch{ error in
                        print("Error in getting high and low temp values \(error.localizedDescription)")
                    }
                
                let fiveDayURL = self.getFiveDayURL(key)
                
                print(fiveDayURL)
                
                self.getFiveDayConditions(fiveDayURL)
                    .done { (DayMaxMins) in
                        self.dayMaxMinArr = [DayMaxMin]()
                        
                        for dayMaxMin in DayMaxMins {
                            self.dayMaxMinArr.append(dayMaxMin)
                        }
                        self.tblDayMaxMin.reloadData()
                    }
                    .catch{ error in
                        print("Error in getting day, max and min temp values \(error.localizedDescription)")
                    }
                
            }
            .catch { error in
                print("Error in getting city data \(error.localizedDescription)")
            }
    }
    
}

//MARK: Getting the api URLs
extension ViewController{
    
    func getLocationURL(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees) -> String{
        var url = locationURL
        url.append(apiKey)
        url.append("&q=\(lat),\(lng)")
        return url
    }
    
    func getCurrentConditionURL(_ cityKey : String) -> String{
        var url = currentConditionURL
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getOneDayURL(_ cityKey : String) -> String{
        var url = oneDayURL
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getFiveDayURL(_ cityKey : String) -> String{
        var url = fiveDayURL
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    
}

//MARK: Promises
extension ViewController{
    
    func getLocationData(_ url : String) -> Promise<(String, String)>{
        
        return Promise<(String, String)> { seal -> Void in
            
            AF.request(url).responseJSON { response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let locationJSON : JSON = JSON(response.data as Any)
                let key = locationJSON["Key"].stringValue
                let city = locationJSON["LocalizedName"].stringValue
                seal.fulfill( (key, city) )
                
            }
        }
    }
    
    func updateWeatherData(_ url : String) -> Promise<(String, Int)> {
        return Promise<(String, Int)> { seal -> Void in
            
            AF.request(url).responseJSON { response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let locationJSON : [JSON] = JSON(response.data as Any).arrayValue
                
                let condition = locationJSON[0]["WeatherText"].stringValue
                let temp = locationJSON[0]["Temperature"]["Imperial"]["Value"].intValue
                
                seal.fulfill( (condition, temp) )
                
            }
            
        }
    }
    
    func getOneDayConditions(_ url : String) -> Promise<(Int, Int)> {
        
        return Promise<(Int, Int)> { seal -> Void in
            
            AF.request(url).responseJSON { response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let oneDayJSON : JSON = JSON(response.data as Any)
                
                let low = oneDayJSON["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
                let high = oneDayJSON["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue
                
                seal.fulfill( (low, high) )
                
            }
        }
        
    }
    
    func getFiveDayConditions(_ url : String) -> Promise<[DayMaxMin]> {
        
        return Promise<[DayMaxMin]> { seal -> Void in
            
            AF.request(url).responseJSON { response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                
                var arr = [DayMaxMin]()
                
                guard let data = response.data else {return seal.fulfill( arr ) }
                
                guard let temp = JSON(data).dictionary else {return  seal.fulfill( arr )}
                
                let DayMaxMins = temp["DailyForecasts"]?.array;
                
                if DayMaxMins!.count == 0 { return }
                
                self.dayMaxMinArr = [DayMaxMin]()
                
                for dayMaxMin in DayMaxMins! {
                    
                    let temp = dayMaxMin["Date"].stringValue
                    let index = temp.index(temp.startIndex, offsetBy: 10)
                    let mySubstring = temp[..<index]
                    let day = self.getDayNameBy(stringDate: String(mySubstring))
                    let max = dayMaxMin["Temperature"]["Maximum"]["Value"].intValue
                    let min = dayMaxMin["Temperature"]["Minimum"]["Value"].intValue
                    
                    let dayMaxMin = DayMaxMin()
                    dayMaxMin.day = day
                    dayMaxMin.max = max
                    dayMaxMin.min = min
                    self.dayMaxMinArr.append(dayMaxMin)
                    arr.append(dayMaxMin)
                    
                }
                seal.fulfill(arr)
            }
        }
        
    }
    
    func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
}
