//
//  StructureModel.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import RealmSwift

//var favsArray = ["deal1", "deal2", "deal3"]

struct DealJson {
  var daysAvalable: [String]?
  var dealID: String? //primary key
  var dealName: String?
  var img: String?
  var price: String?
//  var tags: [String]?
  var placeid: String?
  var style: [String]?
//  var dealFaved: Bool

//  init(dealID: Int, dealName: String) {
//    self.dealID = dealID
//    self.dealName = dealName
//    self.dealFaved = false
//  }
}

class Deal: Object {
  @objc dynamic var dealID = 0 //primary key
  @objc dynamic var dealName = ""
  @objc dynamic var dealImageUrl = ""
  @objc dynamic var price = ""
  @objc dynamic var tags = ""
  @objc dynamic var placeID = 0
  @objc dynamic var styleID = 0
  @objc dynamic var dealFaved = false

}

struct Place {
  var placeID: Int //primary key
  var placeName: String
  var phoneNumber: String
  var placeCoordinates: (placeLong: Double,
                        placeLat: Double)
  var placeLocation: (String
//                      city: String, //keeping this in my class just in case
//                      state: String, //keeping this in my class just in case
//                      zip: String, //keeping this in my class just in case
//                      country: String //keeping this in my class just in case
)}

struct Style {
  var styleID: Int //primary key
  var styleName: String
}

struct User {
  var userID: Int //primary key
  var userLatitude: Double //local only
  var userLongitude: Double //local only
  var email: String
  var password: String
  var dealLog: [Int] //dealID, keeping this in my class for later
  var dealFavs: [Int] //dealID
//  var reviews: (placeID: Int, reviewText: String) // possible future use
}
