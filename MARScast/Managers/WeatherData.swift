//
//  WeatherData.swift
//  MARScast
//
//  Created by Razvan-Antonio Berbece on 09/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WeatherOnMars : Codable {
    let AT : AT
    
    struct AT: Codable {
        let av : Int
        let ct : String
        let mn : Int
        let mx : Int
    }
}


