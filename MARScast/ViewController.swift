//
//  ViewController.swift
//  MARScast
//
//  Created by Razvan-Antonio Berbece on 08/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class ViewController: UIViewController {
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    var lastDayChecked : Int = 0
    var currentTemperature : String = ""
    var isWarm : Bool = true // Compared to average on Mars of 65
    
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
                    //  print(self.currentTemperature)
                    let intTemperature = Int(self.currentTemperature) ?? 0
                    if intTemperature > -60 {
                        self.isWarm = true
                    }
                    else if intTemperature < -70 {
                        self.isWarm = false
                    }
                    DispatchQueue.main.async {
                        self.mainDegrees.text = self.currentTemperature
                        if self.isWarm == true {
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
