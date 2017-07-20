//
//  Configuration.swift
//  StormyWeather
//
//  Created by Maik Rengsberger on 19.07.17.
//  Copyright © 2017 Maik Rengsberger. All rights reserved.
//

import Foundation

struct DefaultLocation {
    static let Latitude: Double = 51.0509912
    static let Longitude: Double = 13.7336335
}

struct API {
    
    static let APIKey = "4db87fec324b42b4c8172cc9ace1a174"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
    
}

