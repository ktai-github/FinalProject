//
//  RealmManager.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-13.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {

//  for simplicity, deals and places nodes from firebase are combined into one record DealPlace in realm data persistence
  static func realmQueryAllRecords() -> (Results<DealPlace>) {
    let realm = try! Realm()
    let dealPlaces = try! realm.objects(DealPlace.self)
    return dealPlaces
  }
  
  static func realmAdd(dealPlace: DealPlace) {
    let realm = try! Realm()
    try! realm.write {
      realm.add(dealPlace)
      print("added \(dealPlace.dealName) to realm")
    }
  }
  
  static func realmDelete(_ unwDealName: String, _ dealPlace: DealPlace) {
    
    let realm = try! Realm()
    let dealPlaces = realm.objects(DealPlace.self).filter("dealName = '\(unwDealName)'").first
    
    try! realm.write {
      realm.delete(dealPlaces!)
      print("deleted \(dealPlace.dealName) from realm")
    }
  }
  
}
