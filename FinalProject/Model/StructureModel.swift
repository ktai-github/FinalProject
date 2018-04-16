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

class DealPlace: Object {
//  @objc dynamic var dealID = 0 //primary key
  @objc dynamic var dealName = ""
  @objc dynamic var dealImageUrl = ""
  @objc dynamic var dealPrice = ""
//  @objc dynamic var tags = ""
  @objc dynamic var placeID = ""
  @objc dynamic var dealStyle = ""
  @objc dynamic var dealFaved = false
  @objc dynamic var placeName = ""
  @objc dynamic var placePhone = ""
  @objc dynamic var placeAddress = ""
  @objc dynamic var placeLat = ""
  @objc dynamic var placeLong = ""

//  let unwPlaceName = tempPlaceFirebase.name,
//  let unwPlaceAddress = tempPlaceFirebase.address,
//  let unwPlaceLat = tempPlaceFirebase.lat,
//  let unwPlaceLong = tempPlaceFirebase.lon,
//  let unwPlaceID = tempPlaceFirebase.placeID,
//  let unwPlacePhone = tempPlaceFirebase.phone
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
