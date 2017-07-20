//
//  DataManager.swift
//  StormyWeather
//
//  Created by Maik Rengsberger on 19.07.17.
//  Copyright © 2017 Maik Rengsberger. All rights reserved.
//

import Foundation


enum DataManagerError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

final class DataManager {
    
    typealias WeatherDataCompletion = (AnyObject?, DataManagerError?) -> ()
    var curForecastArray:[Currently] = []
    var dailyForecastArray:[DailyForecast] = []
    var baseURL: URL
    
    // MARK: - Initialization
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Requesting Data
    
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        // Create URL
        //let URL = baseURL.appendingPathComponent("\(latitude),\(longitude)")
        let url = "\(baseURL)" + "/" + "\(latitude),\(longitude)"+"?lang=de&units=us"
        // Create Data Task
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    // MARK: - Helper Methods
    
    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
            
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func processWeatherData(data: Data, completion: WeatherDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
            if let dailyForecasts = JSON["daily"] as? [String:Any] {
                if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                    for dataPoint in dailyData {
                        if let weatherObject = try? DailyForecast(json: dataPoint) {
                            dailyForecastArray.append(weatherObject)
//                            print(weatherObject.summary)
//                            print(weatherObject.temperatureMin)
//                            print(weatherObject.temperatureMax)
                        }
                    }
                }
            }
            
            if let currentlyForecasts = JSON["currently"]  {
                if let weatherObject = try? Currently(json: currentlyForecasts as! [String : Any]) {
                    print("jetzt: \(weatherObject.temperature)")
                    print("jetzt: \(weatherObject.summary)")
                    print("jetzt: \(weatherObject.icon)")
                    print("jetzt: \(weatherObject.uvIndex)")
                    print("jetzt: \(weatherObject.windSpeed)")
                    print("jetzt: \(weatherObject.humidity)")
                    print("jetzt: \(weatherObject.pressure)")
                    curForecastArray.append(weatherObject)
                }
                
            }
            completion(JSON, nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
}
