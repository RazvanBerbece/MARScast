//
//  SecondaryVC.swift
//  MARScast
//
//  Created by Razvan-Antonio Berbece on 27/01/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyGif
import Kingfisher

class SecondaryVC: UIViewController {
    
    @IBOutlet weak var marsLatestPhoto: UIImageView!
    @IBOutlet weak var picDate: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    private let photoDataManager = PhotoDataManager(baseURL: API.baseURLStringPhotos)
    
    var lastDayCheckedPhotos : Int = 0
    var latestPhotoURL : String = ""
    var dateString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding the gif overlay for the stars effect
        do {
            let gif = try UIImage(gifName: "starsgif.gif")
            background = UIImageView(gifImage: gif, loopCount: -1) // Use -1 for infinite loop
            background.frame = view.bounds
            background.alpha = 0.199
            view.insertSubview(background, at: 1)
        } catch {
            print(error)
        }
        
        //  Changing the imageView to a rounded image
        self.marsLatestPhoto.layer.masksToBounds = true
        self.marsLatestPhoto.layer.cornerRadius = self.marsLatestPhoto.frame.width / 4.0
        
        photoDataManager.getLatestPhotoOnMars(_apikey: API.key) { (data) in
            switch data.isEmpty {
            case true:
                print("Photo package seems to be empty. Retry.")
            case false:
                print("Succesfully retrieved photo data.")
                let json = String(data: data, encoding: .utf8)
                let jsonData = json!.data(using: .utf8)
                if let json = try? JSON(data: jsonData!)
                {
                    //  Getting the last day with a photo taken
                    for item in json["latest_photos"]
                    {
                        //  print(item.stringValue)
                        self.lastDayCheckedPhotos += 1
                    }
                    self.latestPhotoURL = String(describing: json["latest_photos"][self.lastDayCheckedPhotos - 1]["img_src"])
                    self.dateString = String(describing: json["latest_photos"][self.lastDayCheckedPhotos - 1]["earth_date"])
                    //  print(self.latestPhotoURL)
                    DispatchQueue.main.async {
                        let photoURL = URL(string: "\(self.latestPhotoURL)")
                        self.marsLatestPhoto.kf.setImage(with: photoURL)    //  Also caching the image to avoid double loading
                        self.picDate.text = "Picture taken on : " + "\(self.dateString)"
                    }
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
