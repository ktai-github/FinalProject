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
  let regionRadius: CLLocationDistance = 1000
  
  var selectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  override func viewDidLoad() {
        super.viewDidLoad()

//    let favDeals = RealmManager.realmQueryAllRecords()

//    print("lat: " + favDeals[0].placeLat)
//    print("long: " + favDeals[0].placeLong)
//    print("menu item selected: " + String(describing: selectedDealCategory))
    
//    mapVC.placeCoordinateLatitude = (unwPlaceCoordinateLatitude as NSString).doubleValue
//    mapVC.placeCoordinateLongitude = (unwPlaceCoordinateLongitude as NSString).doubleValue
//
//    mapVC.placeName = placeName

    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      
      let favDeals = RealmManager.realmQueryAllRecords()
      
      for i in 0..<favDeals.count {
        
        let tempCoordinateLocation = CLLocation(latitude: (favDeals[i].placeLat as NSString).doubleValue , longitude: (favDeals[i].placeLong as NSString).doubleValue)
        
        centerMapOnLocation(location: tempCoordinateLocation)
        
        let tempCoordinateLocation2D = CLLocationCoordinate2D(latitude: (favDeals[i].placeLat as NSString).doubleValue , longitude: (favDeals[i].placeLong as NSString).doubleValue)

        let anno = MKPointAnnotation()
        anno.coordinate = tempCoordinateLocation2D
        anno.title = favDeals[i].placeName
        
        mapView.addAnnotation(anno)
        print("added: \(tempCoordinateLocation2D.latitude)")
        print("added: \(tempCoordinateLocation2D.longitude)")
      }
    } else {
    
      let initialLocation = CLLocation(latitude: placeCoordinateLatitude, longitude: placeCoordinateLongitude)

      centerMapOnLocation(location: initialLocation)
      
      let initialLocation2D = CLLocationCoordinate2D(latitude: placeCoordinateLatitude, longitude: placeCoordinateLongitude)
      
      let anno = MKPointAnnotation()
      anno.coordinate = initialLocation2D
      anno.title = placeName
      
      mapView.addAnnotation(anno)
    
//    guard let unwPlaceName = placeName else {
//      print("cannot unwrap place")
//      return
//    }
    // Do any additional setup after loading the view.
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
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
