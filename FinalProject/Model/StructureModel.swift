//
//  StructureModel.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import RealmSwift

struct DealFirebase {
  var daysAvalable: String?
  var dealID: String? //primary key
  var dealName: String?
  var img: String?
  var price: String?
  var placeid: String?
  var style: String?
}

struct PlaceFirebase {
  var placeID: String? //primary key
  var name: String?
  var phone: String?
  var lat: String?
  var lon: String?
  var address: String?
}


//  DealPace is used to combine deal and place data when user saves it
//  Combining deal and place data is done to persist data on Realm
class DealPlace: Object {
  @objc dynamic var dealName = ""
  @objc dynamic var dealImageUrl = ""
  @objc dynamic var dealPrice = ""
  @objc dynamic var dealDaysAvailable = ""
  @objc dynamic var placeID = ""
  @objc dynamic var dealStyle = ""
  @objc dynamic var dealFaved = false
  @objc dynamic var placeName = ""
  @objc dynamic var placePhone = ""
  @objc dynamic var placeAddress = ""
  @objc dynamic var placeLat = ""
  @objc dynamic var placeLong = ""
}
