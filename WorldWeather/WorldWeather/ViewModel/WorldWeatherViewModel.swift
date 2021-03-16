//
//  CityViewModel.swift
//  WorldWeather
//
//  Created by Sahana Adarsh on 10/03/21.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON


class WorldWeatherViewModel{
    
    var fiveDayForecastArr: [ModelFiveDayForecast] = [ModelFiveDayForecast]()
    
    func getCityData(_ url : String) -> Promise<ModelCity> {
        
        return Promise<ModelCity>{ seal ->Void in
            
            getAFResponseJSON(url).done { json in
                
                let key = json["Key"].stringValue
                let city = json["LocalizedName"].stringValue
                let cityModel: ModelCity = ModelCity(key, city)
                
                seal.fulfill(cityModel)
            }
            .catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getCurrentConditions(_ url : String) -> Promise<ModelCurrentCondition>{
        return Promise<ModelCurrentCondition> { seal ->Void in
            
            getAFResponseJSONArray(url).done { currentWeatherJSON in
                
                let weatherText = currentWeatherJSON[0]["WeatherText"].stringValue
                let weatherIcon = currentWeatherJSON[0]["WeatherIcon"].intValue
                let isDayTime = currentWeatherJSON[0]["IsDayTime"].boolValue
                let metricTemp = currentWeatherJSON[0]["Temperature"]["Metric"]["Value"].floatValue
                let imperialTemp = currentWeatherJSON[0]["Temperature"]["Imperial"]["Value"].intValue
                
                let currCondition = ModelCurrentCondition(weatherText, metricTemp, imperialTemp)
                currCondition.weatherIcon = weatherIcon
                currCondition.isDayTime  = isDayTime
                
                
                seal.fulfill(currCondition)
                
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getOneDayConditions(_ url : String) -> Promise<ModelOneDayForecast>{
        return Promise<ModelOneDayForecast> { seal -> Void in
            
            getAFResponseJSON(url).done { json in
                
                let dayForecast = ModelOneDayForecast()
                dayForecast.headlineText = json["Headline"]["Text"].stringValue
                dayForecast.nightTemp = json["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
                dayForecast.dayTemp = json["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue
                dayForecast.dayIcon = json["DailyForecasts"][0]["Day"]["Icon"].intValue
                dayForecast.nightIcon = json["DailyForecasts"][0]["Night"]["Icon"].intValue
                dayForecast.dayIconPhrase = json["DailyForecasts"][0]["Day"]["IconPhrase"].stringValue
                dayForecast.nightIconPhrase = json["DailyForecasts"][0]["Night"]["IconPhrase"].stringValue
                
                seal.fulfill(dayForecast)
                
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getFiveDayConditions(_ url : String) -> Promise<[ModelFiveDayForecast]> {
        
        return Promise<[ModelFiveDayForecast]> { seal -> Void in
            
            getAFResponseJSON(url).done { json in
                
                var arr = [ModelFiveDayForecast]()
                
                let fiveDayTempData = json["DailyForecasts"].array;
                
                if fiveDayTempData!.count == 0 { return }
                
                self.fiveDayForecastArr = [ModelFiveDayForecast]()
                
                for eachDay in fiveDayTempData! {
                    let fiveDayForecast = ModelFiveDayForecast()
                    let tempDay = eachDay["Date"].stringValue
                    let index = tempDay.index(tempDay.startIndex, offsetBy: 10)
                    let mySubstring = tempDay[..<index]
                    let dayOfweek = self.getDayNameBy(stringDate: String(mySubstring))
                    fiveDayForecast.day = dayOfweek
                    fiveDayForecast.dayTemp = eachDay["Temperature"]["Maximum"]["Value"].intValue
                    fiveDayForecast.nightTemp = eachDay["Temperature"]["Minimum"]["Value"].intValue
                    fiveDayForecast.dayIcon = eachDay["Day"]["Icon"].intValue
                    fiveDayForecast.nightIcon = eachDay["Night"]["Icon"].intValue
                    self.fiveDayForecastArr.append(fiveDayForecast)
                    arr.append(fiveDayForecast)
                }
                seal.fulfill(arr)
            }
            .catch { error in
                seal.reject(error)
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
