//
//  ViewController.swift
//  MARScast
//
//  Created by Razvan-Antonio Berbece on 08/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class ViewController: UIViewController {
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground(contentMode: .center)
        
        mainDegrees.text = dataManager.getWeatherOnMars(_apikey: API.key)
    }
}
