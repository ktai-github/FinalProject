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
  
  var placeCoordinateLatitude: Double = 0.0
  var placeCoordinateLongitude: Double = 0.0
  
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
        
//        let tempCoordinateLocation2D = CLLocationCoordinate2D(latitude: (favDeals[i].placeLat as NSString).doubleValue , longitude: (favDeals[i].placeLong as NSString).doubleValue)
//
//        let anno = MKPointAnnotation()
//        anno.coordinate = tempCoordinateLocation2D
//        anno.title = favDeals[i].placeName
//
//        mapView.addAnnotation(anno)
        
        let regionCenterLocation = CLLocation(latitude: 49.283854 , longitude: -123.108070)
        centerMapOnLocation(location: regionCenterLocation)
      }
    
//    access map vc from clicking map on deal vc
    } else {
    
      let location = CLLocation(latitude: placeCoordinateLatitude, longitude: placeCoordinateLongitude)

      centerMapOnLocation(location: location)
      
      createAnno(annoLatitude: placeCoordinateLatitude, annoLongitude: placeCoordinateLongitude, annoTitle: placeName!)
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
