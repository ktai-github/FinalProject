//
//  StructureModel.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit

var favsArray = ["deal1", "deal2"]

struct Deal {
  var dealID: Int //primary key
  var dealName: String
  var dealImageUrl: String?
  var price: String?
  var tags: [String]?
  var placeID: Int?
  var styleID: Int?
  
  init(dealID: Int, dealName: String) {
    self.dealID = dealID
    self.dealName = dealName
  }
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
