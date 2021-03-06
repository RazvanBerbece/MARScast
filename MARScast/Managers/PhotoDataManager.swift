//
//  DataManager.swift
//  MARScast
//
//  Created by Razvan-Antonio Berbece on 27/01/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import SwiftyJSON

final class PhotoDataManager {
    
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func getLatestPhotoOnMars(
        _apikey: String,
        completion: @escaping ((_ data: Data) -> Void))
    {
        let url = URL(string: baseURL)
        // ?api_key=\(key)/&feedtype=json&ver=1.0"
        let path = "?api_key=\(_apikey)"
        let finalURL = url.flatMap
        {
            URL(string: $0.absoluteString + path)
        }
        
        // var lastTemp : String = ""
        // Set up the call and fire it off
        print("Connecting to \(String(describing: finalURL)) ...")
        let task = URLSession.shared.dataTask(with: finalURL!, completionHandler: {
            (data, response, error) in
            if let error = error {
                print(error)
            }
            
            //  Checking data size for debugging purposes
            if let data = data {
                print("\(data)")
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    completion(data!)
                } else {
                    //completion(nil)
                }
            }
        })
        task.resume()
    }
}

