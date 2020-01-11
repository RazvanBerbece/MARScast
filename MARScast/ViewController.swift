//
//  ViewController.swift
//  MARScast
//
//  Created by Razvan-Antonio Berbece on 10/01/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class ViewController: UIViewController {
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var windSpeedDisplay: UILabel!
    
    var lastDayChecked : Int = 0
    var currentTemperature : String = ""
    
    var windSpeed : String = ""
    
    var isWarm : Bool = true // Compared to average on Mars of 65
    var isAverage : Bool = false // Average temperature reached
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getWeatherOnMars(_apikey: API.key, completion:  {
            data in
            switch data.isEmpty {
            case true:
                print("The data received appears to be empty. Try again.")
            case false:
                let json = String(data: data, encoding: .utf8)
                let jsonData = json!.data(using: .utf8)
                if let json = try? JSON(data: jsonData!)
                {
                    for item in json["sol_keys"].arrayValue
                    {
                        //  print(item.stringValue)
                        self.lastDayChecked = Int(item.stringValue)!
                    }
                    self.currentTemperature = String(describing: json["\(self.lastDayChecked)"]["AT"]["av"])
                    self.windSpeed = String(describing: json["\(self.lastDayChecked)"]["HWS"]["av"])
                    //  print(self.currentTemperature)
                    let floatTemperature = Float(self.currentTemperature) ?? 0
                    let temperatureInCelsius = (floatTemperature - 32) * 5/9
                    if temperatureInCelsius > -50 {
                        self.isWarm = true
                    }
                    else if temperatureInCelsius < -58 {
                        self.isWarm = false
                    }
                    else if temperatureInCelsius < -50 && temperatureInCelsius > -58 {
                        self.isAverage = true
                    }
                    let celsiusString = String(temperatureInCelsius).prefix(5)
                    DispatchQueue.main.async {
                        self.mainDegrees.text = celsiusString + " °C"
                        self.windSpeedDisplay.text = "Wind speed is : " + self.windSpeed + " m/s"
                        if self.isAverage == true {
                            self.mainDesc.text = "It is an average temperature on Mars currently ..."
                        }
                        else if self.isWarm == true {
                            self.mainDesc.text = "It is quite warm on Mars compared to usual average ..."
                        }
                        else {
                            self.mainDesc.text = "It is quite cold on Mars compared to usual average ..."
                        }
                    }
                }
            }
        })
    }
}
