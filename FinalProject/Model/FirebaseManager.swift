//
//  FirebaseManager.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-14.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseManager: NSObject {

  var ref: DatabaseReference!
  var databaseHandle: DatabaseHandle?
  var dealsData = [Any]()
  
  static func loadFromFirebase(node: String) {
    
  }
}
