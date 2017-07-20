//
//  Currently.swift
//  StormyWeather
//
//  Created by Maik Rengsberger on 19.07.17.
//  Copyright © 2017 Maik Rengsberger. All rights reserved.
//

import Foundation
import UIKit

struct Currently {
    let summary:String
    let icon:String
    let temperature:Double
    let uvIndex: Int
    let windSpeed: Double
    let pressure: Double
    let humidity: Double
    let precipitation: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let uvIndex = json["uvIndex"] as? Int else {throw SerializationError.missing("temp is missing")}
        
        guard let windSpeed = json["windSpeed"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let pressure = json["pressure"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let precipitation = json["precipProbability"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.uvIndex = uvIndex
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.humidity = humidity
        self.precipitation = precipitation
    }
}
