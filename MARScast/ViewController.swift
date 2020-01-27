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
import SwiftyGif

class ViewController: UIViewController {
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var windSpeedDisplay: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var marsGIF: UIImageView!
    
    var lastDayChecked : Int = 0
    var currentTemperature : String = ""
    
    var windSpeed : String = ""
    
    var isWarm : Bool = true // Compared to average on Mars of 65
    var isAverage : Bool = false // Average temperature reached
    
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(
            title: "Comparison Alert",
            message:
            "Average wind speed on Earth: \n\n 10m Ocean-level: 6.64 m/s \n 10m Land-level: 3.28 m/s",
            preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ToSecondaryVC(sender: AnyObject) {
        self.performSegue(withIdentifier: "SecondaryVC", sender: sender)
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        // Designed to perform unwind action from SecondaryVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Adding swipe gesture recognizer in order to change ViewController to SecondaryVC
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.ToSecondaryVC))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Adding the gif overlay for the stars effect
        do {
            let gif = try UIImage(gifName: "starsgif.gif")
            let gif2 = try UIImage(gifName: "marsGIF.gif")
            
            background = UIImageView(gifImage: gif, loopCount: -1) // Use -1 for infinite loop
            background.frame = view.bounds
            background.alpha = 0.199
            
            marsGIF = UIImageView(gifImage: gif2, loopCount: -1) // Use -1 for infinite loop
            marsGIF.frame = CGRect(x: view.bounds.maxX - 220, y: view.bounds.maxY - 180, width: 75.0, height: 75.0)
            marsGIF.alpha = 1
            
            self.view.insertSubview(background, at: 1)
            self.view.insertSubview(marsGIF, at: 2)
            
        } catch {
            print(error)
        }
        
        dataManager.getWeatherOnMars(_apikey: API.key, completion:  {
            data in
            switch data.isEmpty {
            case true:
                print("The data package appears to be empty. Try again.")
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
