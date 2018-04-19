//
//  DealsCollectionViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-18.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit

class DealsCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var selectedDealCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals

  var tempDealFirebase = DealFirebase()
  var tempPlaceFirebase = PlaceFirebase()
  
//  var dealsList = [DealFirebase]()

  let photoManager = PhotoManager()
//  var tempDealID = 0
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dealsList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let dealsCollectionViewCell: DealsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! DealsCollectionViewCell
    let deal = dealsList[indexPath.row]
//    tempDealID = indexPath.row
    photoManager.photoNetworkRequest(url: deal.img!) { (image: UIImage) in
      
      DispatchQueue.main.async {
        dealsCollectionViewCell.imageView.image = image
      }
    }
    return dealsCollectionViewCell

  }
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: self.collectionView.frame.height / 15, height: self.collectionView.frame.height / 15)
//    
//  }

//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    performSegue(withIdentifier: "unwindSegueFromCollectionToDealVC", sender: self)
//
//  }

    override func viewDidLoad() {
        super.viewDidLoad()
      collectionView.delegate = self
      collectionView.dataSource = self
//      collectionView.layout
//      FirebaseManager.defaultManager.fetchDeals {
//
//        print("fetched deals")
//      }
//      FirebaseManager.defaultManager.fetchPlaces {
////        DispatchQueue.main.async {
////          self.loadDetails()
////        }
//      }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
//  func loadPhotoFromNetwork(imageUrl: String) -> Void {
//    let photoManager = PhotoManager()
//    photoManager.photoNetworkRequest(url: imageUrl) { (image: UIImage) in
//
//      DispatchQueue.main.async {
//        self.collectionView..imageView.image = image
//      }
//    }
//
//  }

  //MARK: Load Details on Screen
//  fileprivate func applyFilter(_ filteredDealsList: inout [DealFirebase], category: String) {
//    for deal in dealsList {
//      if (deal.style?.contains(category))! {
//        filteredDealsList.append(deal)
//      }
//    }
//    print("filtered \(category) deals only")
//  }
  
//  func loadDetails() -> () {
//    
//    var filteredDealsList = [DealFirebase]()
//    
////    switch selectedDealCategory {
////
////    case enumSelectedDealCategory.enumFoodDeals:
////      applyFilter(&filteredDealsList, category: "Food")
////
////    //      fun category currently not available
////    case enumSelectedDealCategory.enumFunDeals:
////      applyFilter(&filteredDealsList, category: "Fun")
////
////    case enumSelectedDealCategory.enumDrinkDeals:
////      applyFilter(&filteredDealsList, category: "Drinks")
////
////    case enumSelectedDealCategory.enumDateDeals:
////      applyFilter(&filteredDealsList, category: "Date")
////
////    //      group category currently not available
////    case enumSelectedDealCategory.enumGroupDeals:
////      applyFilter(&filteredDealsList, category: "Group")
////
////    default:
//    
//      //      dummy filter
//      filteredDealsList = dealsList
////    }
//    
////    let dealNumber = Int(arc4random_uniform(UInt32(filteredDealsList.count)))
//    
//    loadPhotoFromNetwork(imageUrl: filteredDealsList[dealNumber].img!)
//    
//    //    potentially to be used to save deal for later if the user chooses to
//    tempDealFirebase = filteredDealsList[dealNumber]
//    //    dealLabel.isHidden = false
//    dealLabel.text = filteredDealsList[dealNumber].dealName
//    priceLabel.text = filteredDealsList[dealNumber].price
//    styleLabel.text = filteredDealsList[dealNumber].style
//    daysAvailableLabel.text = filteredDealsList[dealNumber].daysAvalable
//    
//    for placeFB in placesList {
//      if placeFB.placeID == filteredDealsList[dealNumber].placeid {
//        
//        //    potentially to be used to save deal for later if the user chooses to
//        tempPlaceFirebase = placeFB
//        
//        addressLabel.text = placeFB.address
//        placeNameLabel.text = placeFB.name
//        phoneLabel.text = placeFB.phone
//        guard let unwLatitude = placeFB.lat, let unwLongitude = placeFB.lon else {
//          print("cannot unwrap lat long")
//          return
//        }
//        
////        //        potentially to be used for mapview if user chooses to see on map
////        placeCoordinateLatitude = unwLatitude
////        placeCoordinateLongitude = unwLongitude
////
////        guard let unwPlaceName = placeFB.name else {
////          print("cannot unwrap place name")
////          return
////        }
////        placeName = unwPlaceName
//      }
//    }
//    
//  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    // Get the new view controller using segue.destinationViewController.
//    // Pass the selected object to the new view controller.
//    if segue.identifier == "unwindSegueFromCollectionToDealVC" {
//
//      let dealVC = segue.destination as! DealViewController
////      dealVC.selectedDealCategory = userSelectedCategory
////      dealVC.tempDealID = tempDealID
//    }
//    
//  }

}
