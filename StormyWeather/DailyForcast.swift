//
//  DailyForcast.swift
//  StormyWeather
//
//  Created by Maik Rengsberger on 19.07.17.
//  Copyright © 2017 Maik Rengsberger. All rights reserved.
//

import Foundation
import UIKit

struct DailyForecast {
    let summary:String
    let icon:String
    let temperatureMax:Double
    let temperatureMin:Double
    let sunriseTime: Int
    let sunsetTime: Int
    let uvIndex: Int
    let windSpeed: Double
    let pressure: Double
    let humidity: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperatureMax = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let temperatureMin = json["temperatureMin"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let sunriseTime = json["sunriseTime"] as? Int else {throw SerializationError.missing("temp is missing")}
        
        guard let sunsetTime = json["sunsetTime"] as? Int else {throw SerializationError.missing("temp is missing")}
        
        guard let uvIndex = json["uvIndex"] as? Int else {throw SerializationError.missing("temp is missing")}
        
        guard let windSpeed = json["windSpeed"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let pressure = json["pressure"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("temp is missing")}

        
        self.summary = summary
        self.icon = icon
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
        self.uvIndex = uvIndex
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.humidity = humidity
    }
}
