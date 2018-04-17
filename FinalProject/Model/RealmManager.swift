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

  static func realmQueryAllRecords() -> (Results<DealPlace>) {
    let realm = try! Realm()
    let deals = try! realm.objects(DealPlace.self)
    return deals
  }
  
  static func realmAdd(deal: DealPlace) {
    let realm = try! Realm()
    try! realm.write {
      realm.add(deal)
      print("added \(deal.dealName) to realm")
    }
  }
  
  static func realmDelete(_ unwDealName: String, _ deal: DealPlace) {
    
    let realm = try! Realm()
    let deals = realm.objects(DealPlace.self).filter("dealName = '\(unwDealName)'").first
    
    try! realm.write {
      realm.delete(deals!)
      print("deleted \(deal.dealName) from realm")
    }
  }
  
}
