//
//  ViewController.swift
//  WorldWeather
//
//  Created by Sahana Adarsh on 08/03/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit

/*
 Localization Steps:
 1. Click on the Project in the left top bar
 2. Select the project from the Project in the main screen
 3. In the Localizations section Click on + button to add your localized language
 4. Create a local folder and call it Localizable
 5. Add a new Strings file and call it Localizable too
 6. Add a key value pair in the file like following "hello_world" = "Hello World"; // remember to terminate string by semi colon
 7. Click on the Localizable.string file and in the right menu (identity inspector) you will see a Localization section
 8. Click on the Localize button in the Localization section
 9. In the Pop up click on Localize
 10. In the identity inspector check for all the languages you want to localize
 11. Create a file called Utilities
 12. Add a Swift file called LocalizationUtil.swift
 13. Add a variable for the string you want to localize and localize it with the Key added in the strings file as follows
 14. var strHelloWorld = NSLocalizedString("hello_world", comment: "")
 15. Replace Corresponding text in the language files with localized text
 16. Add a function which will initialize the text for all the UI Elements
 17. Call the initialize text from the viewDidLoad()
 
 */

class WorldWeatherViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var weatherViewModel : WorldWeatherViewModel!

    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
        
    @IBOutlet var currCondWeatIcon: UIImageView!
    
    @IBOutlet weak var lblTemperature: UILabel!
        
    @IBOutlet var currDayIcon: UIImageView!
    
    @IBOutlet weak var lblHighLow: UILabel!
        
    @IBOutlet var currNightIcon: UIImageView!
        
    @IBOutlet var tblView: UITableView!
    
    var tempArr: [ModelFiveDayForecast] = [ModelFiveDayForecast]()
    
    let locationManager = CLLocationManager()
    
    let imageArray = ["1", "2", "3", "4",  "5", "6", "7", "8", "9", "10",
                      "11",  "12", "13", "14", "15",  "16", "17", "18", "19",  "20",
                      "21",  "22", "23", "24", "25",  "26", "27", "28", "29",  "30",
                      "31",  "32", "33", "34", "35",  "36", "37", "38", "39",  "40",
                      "41",  "42", "43", "44"]
    
    // We need to have a class of View Model
    let viewModel = WorldWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeText()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.weatherViewModel = WorldWeatherViewModel()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tempArr.count)
        return tempArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell

        cell.lblDay.text = "\(tempArr[indexPath.row].day) "
        let dayImage : UIImage = UIImage(named: self.imageArray[tempArr[indexPath.row].dayIcon])!
        cell.dayImg.image = dayImage
        cell.lblMax.text = "\(tempArr[indexPath.row].dayTemp)°F "
        let nightImage : UIImage = UIImage(named: self.imageArray[tempArr[indexPath.row].nightIcon])!
        cell.nightImg.image = nightImage
        cell.lblMin.text = "\(tempArr[indexPath.row].nightTemp)°F "
        print(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func initializeText(){
        self.title = "Weather"
        lblCity.text = strCity
        lblCondition.text = strCondition
        lblTemperature.text = strTemperature
        lblHighLow.text = strHighLow
    }
    
    //MARK: Location Manager functions
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currLocation = locations.last{
            
            let lat = currLocation.coordinate.latitude
            let lng = currLocation.coordinate.longitude
            updateWeatherData(lat, lng)
        }
    }
    
    
    //MARK: Update the weather from ViewModel
    
    func updateWeatherData(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees){
        
        let cityDataURL = getLocationURL(lat, lng)
        
        viewModel.getCityData(cityDataURL).done { city in
            // Update City Name
            self.lblCity.text = city.cityName
            
            let key = city.cityKey
            
            let currentConditionURL = getCurrentConditionURL(key)
            let oneDayForecastURL = getOneDayURL(key)
            let fiveDayForecastURL = getFiveDayURL(key)
                        
            self.viewModel.getCurrentConditions(currentConditionURL).done { currCondition in
                self.lblCondition.text = currCondition.weatherText
                self.currCondWeatIcon.image = UIImage(named: self.imageArray[currCondition.weatherIcon])
                self.lblTemperature.text =  "\(currCondition.imperialTemp)°F"
            }.catch { error in
                print("Error in getting current conditions \(error.localizedDescription)")
            }
            
            self.viewModel.getOneDayConditions(oneDayForecastURL).done { oneDay in
                self.currDayIcon.image = UIImage(named: self.imageArray[oneDay.dayIcon])
                self.lblHighLow.text = "H: \(oneDay.dayTemp)°F        L: \(oneDay.nightTemp)°F"
                self.currNightIcon.image = UIImage(named: self.imageArray[oneDay.nightIcon])
                
            }.catch { error in
                print("Error in getting one day forecast conditions \(error.localizedDescription)")
            }
            
            self.viewModel.getFiveDayConditions(fiveDayForecastURL).done { (fiveDayMaxMins) in
                self.tempArr = fiveDayMaxMins
                self.tblView.reloadData()
            }
            .catch{ error in
                print("Error in getting day, max and min temp values \(error.localizedDescription)")
            }

        }
        .catch { error in
            print("Error in getting City Data \(error.localizedDescription)")
        }
    }
}

