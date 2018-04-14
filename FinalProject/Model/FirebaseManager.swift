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
  
  static let defaultManager = FirebaseManager()
  
  var ref: DatabaseReference!
  var databaseHandle: DatabaseHandle?

  var nodeData = [Any]()
  
  func loadFromFirebase(node: String, completionHandler: (_ nodeData: [Any]) -> Void) {
//    set the firebase reference
    ref = Database.database().reference()
    
    //      retrieve the posts and listen for changes
    databaseHandle = ref?.child(node).observe(.childAdded, with: { (snapshot) in
      //        code to execute when child is added under deals
      //        take the value from the snapshot and added it to the dealsdata array
      //        let deal = snapshot.value as? String
      if let actualSubNode = snapshot.value {
        self.nodeData.append(actualSubNode)
        //          print(actualDeal)
      }
    })
    completionHandler(nodeData)
  }
}
