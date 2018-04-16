//
//  PhotoManager.swift
//  QuotePro
//
//  Created by KevinT on 2018-03-30.
//  Based on code by Chris Dean https://github.com/ChrisJohnDean/QuotePro
//  Copyright © 2018 KevinT. All rights reserved.
//
import UIKit

class PhotoManager: NSObject {
  func photoNetworkRequest(url: String, completionHandler: @escaping (UIImage) -> Void) {
    
    if let url = URL(string: url) {
      
      let data = try? Data(contentsOf: url)
      if let imageData = data, let image = UIImage(data: imageData) {
        
        completionHandler(image)
      }
    }
  }
}
