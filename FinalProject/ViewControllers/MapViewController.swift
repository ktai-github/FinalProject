//
//  MapViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  var placeName: String?
  
  var placeCoordinates: (placeLong: Double?,
                          placeLat: Double?)
  
  let locationManager = CLLocationManager()
  let kRegionRadius: CLLocationDistance = 1000
  
  var selectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  override func viewDidLoad() {
    super.viewDidLoad()

//    access map vc from clicking my deals on menu table vc
    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      
      let favDeals = RealmManager.realmQueryAllRecords()
      
//      create anno with name and coordinate for each fav deal and add to the map
//      index integer seems to be needed to access properties in a for loop
      for i in 0..<favDeals.count {
        
        createAnno(annoLatitude: (favDeals[i].placeLat as NSString).doubleValue, annoLongitude: (favDeals[i].placeLong as NSString).doubleValue, annoTitle: favDeals[i].placeName)
        
        let regionCenterLocation = CLLocation(latitude: 49.283854 , longitude: -123.108070)
        
        centerMapOnLocation(location: regionCenterLocation)
      }
    
//    access map vc from clicking map on deal vc
    } else {
      
      guard case placeCoordinates.placeLat = placeCoordinates.placeLat,
      case placeCoordinates.placeLong = placeCoordinates.placeLong, 
      let placeName = placeName
        else {
        print("cannot unwrap placeCoordinates")
        return
      }
      
      let location = CLLocation(latitude: placeCoordinates.placeLat!, longitude: placeCoordinates.placeLong!)

      centerMapOnLocation(location: location)
      
      createAnno(annoLatitude: placeCoordinates.placeLat!, annoLongitude: placeCoordinates.placeLong!, annoTitle: placeName)
    }
  }
  
  func centerMapOnLocation(location: CLLocation) {
    
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, kRegionRadius, kRegionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    
  }
  
  fileprivate func createAnno(annoLatitude: Double, annoLongitude: Double, annoTitle: String) {
    
    let location2D = CLLocationCoordinate2D(latitude: annoLatitude, longitude: annoLongitude)
    
    //      create anno with name and coordinate and add to the map
    let anno = MKPointAnnotation()
    anno.coordinate = location2D
    anno.title = annoTitle
    
    mapView.addAnnotation(anno)
    print("added: \(String(describing: anno.title))")
  }
  
  func checkLocationAuthorizationStatus() {
    
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      mapView.showsUserLocation = true
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(true)
    checkLocationAuthorizationStatus()
  }
}
