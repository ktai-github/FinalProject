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
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
//    guard let unwPlaceCoordinate = placeCoordinate else {
//      print("cannot unwrap coordinate")
//      return
//    }
    
    let initialLocation = CLLocation(latitude: placeCoordinateLatitude, longitude: placeCoordinateLongitude)
    
    centerMapOnLocation(location: initialLocation)
    
    let initialLocation2D = CLLocationCoordinate2D(latitude: placeCoordinateLatitude, longitude: placeCoordinateLongitude)
    
    let anno = MKPointAnnotation()
    anno.coordinate = initialLocation2D
    anno.title = placeName
    
    mapView.addAnnotation(anno)
    
//    let coordinate = CLLocationCoordinate2DMake(placeCoordinate.latitude, placeCoordinate.longitude)
//    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
    guard let unwPlaceName = placeName else {
      print("cannot unwrap place")
      return
    }
//    mapItem.name = unwPlaceName
//    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        // Do any additional setup after loading the view.
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
