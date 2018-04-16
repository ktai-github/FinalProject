//
//  FirebaseManager.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-14.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import FirebaseDatabase

//var dealsList = [DealFirebase]()
//var placesList = [PlaceFirebase]()

class FirebaseManager: NSObject {
  
  static let defaultManager = FirebaseManager()
  
  var ref: DatabaseReference!
//  var databaseHandle: DatabaseHandle?
//  var refHandle: UInt!

  //  var nodeData = [Any]()


//  func fetchDeals() {
//    refHandle = ref.child("deals").observe(DataEventType.childAdded, with: { [unowned self] (snapshot) in
//
//      if let dictionary = snapshot.value as? [String: Any] {
//        var dealFirebase = DealFirebase()
//        dealFirebase.dealName = dictionary["dealName"] as? String
//        print("printing dealFirebase.dealname " + dealFirebase.dealName!)
//        dealFirebase.img = dictionary["img"] as? String
//        print("printing dealFirebase.img " + dealFirebase.img!)
//        dealFirebase.placeid = dictionary["placeid"] as? String
//        print("printing dealFirebase.placeid " + dealFirebase.placeid!)
//        dealFirebase.price = dictionary["price"] as? String
//        print("printing dealFirebase.price " + dealFirebase.price!)
//        dealFirebase.style = dictionary["style"] as? [String]
//        print("printing dealFirebase.style " + dealFirebase.style!.joined(separator: ", "))
//        dealFirebase.daysAvalable = dictionary["daysAvalable"] as? [String]
//        print("printing dealFirebase.daysAvalable " + dealFirebase.daysAvalable!.joined(separator: ", "))
//
//        dealsList.append(dealFirebase)
//
//      }
//    })
//  }
//
//  func fetchPlaces() {
//    refHandle = ref.child("places").observe(DataEventType.childAdded, with: { [unowned self] (snapshot) in
//
//      if let dictionary = snapshot.value as? [String: Any] {
//        var placeFirebase = PlaceFirebase()
//        placeFirebase.address = dictionary["address"] as? String
//        print("printing placeFirebase.address " + placeFirebase.address!)
//        placeFirebase.lat = dictionary["lat"] as? String
//        print("printing placeFirebase.lat " + placeFirebase.lat!)
//        placeFirebase.lon = dictionary["lon"] as? String
//        print("printing placeFirebase.lon " + placeFirebase.lon!)
//        placeFirebase.name = dictionary["name"] as? String
//        print("printing placeFirebase.name " + placeFirebase.name!)
//        placeFirebase.phone = dictionary["phone"] as? String
//        print("printing placeFirebase.phone " + placeFirebase.phone!)
//        placeFirebase.placeID = dictionary["placeID"] as? String
//        print("printing placeFirebase.placeID " + placeFirebase.placeID!)
//
//        placesList.append(placeFirebase)
//
//      }
//    })
//  }

  
//  func loadFromFirebase(node: String, completionHandler: @escaping (_ actualSubnode: Any) -> Void) {
//    //check out object mapper cocoapod to automate conversion from json to any object you want
//    //
//
////    set the firebase reference
//    ref = Database.database().reference()
//
//    //      retrieve the posts and listen for changes
//    databaseHandle = ref?.child(node).observe(.childAdded, with: { [unowned self] (snapshot) in
//
//      //        code to execute when child is added under deals
//      //        take the value from the snapshot and added it to the dealsdata array
//      //        let deal = snapshot.value as? String
//
//      if let actualSubNode = snapshot.value {
//        completionHandler(actualSubNode)
////        self.nodeData.append(actualSubNode)
//        //          print(actualDeal)
//      }
////      completionHandler(self.nodeData)
//    })
//  }
}
