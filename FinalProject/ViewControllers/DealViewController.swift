//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import RealmSwift

// notification for the category of deal selected in the menu
//extension Notification.Name {
//  static let deal: Notification.Name = Notification.Name("deal")
//}

enum enumSelectedDealCategory {
  case enumRandomDeals
  case enumFoodDeals
  case enumDrinkDeals
  case enumDateDeals
  case enumFunDeals
  case enumGroupDeals
  case enumMyDeals
}

var dealsList = [DealFirebase]()
var placesList = [PlaceFirebase]()

class DealViewController: UIViewController {

  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet var swipeLeftGestRec: UISwipeGestureRecognizer!
  @IBOutlet var swipeRightGestRec: UISwipeGestureRecognizer!
  @IBOutlet var swipeLeftVisualEffect: UISwipeGestureRecognizer!
  @IBOutlet var swipeRightVisualEffect: UISwipeGestureRecognizer!
  @IBOutlet var swipeDownGestRec: UISwipeGestureRecognizer!
  @IBOutlet var swipeDownVisualEffect: UISwipeGestureRecognizer!
  
  @IBOutlet weak var favSwitch: UISwitch!
//  @IBOutlet weak var blackMaskView: UIView!
  @IBOutlet weak var dealLabel: UILabel!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var styleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var daysAvailableLabel: UILabel!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  
  var selectedDealCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  var placeName: String?
  
  var placeCoordinateLatitude: String?
  var placeCoordinateLongitude: String?
  
  var tempDealFirebase = DealFirebase()
  var tempPlaceFirebase = PlaceFirebase()
  
  var tempDealPlace = DealPlace()

//  var isFrontVisible = true
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        FirebaseManager.defaultManager.fetchDeals {
          
          print("fetched deals")
        }
        FirebaseManager.defaultManager.fetchPlaces {
          DispatchQueue.main.async {
            self.loadDetails()
          }
        }
      
//      recognize swiping left and right
      swipeRightGestRec.direction = UISwipeGestureRecognizerDirection.right
      swipeLeftGestRec.direction = UISwipeGestureRecognizerDirection.left
      imageView.addGestureRecognizer(swipeRightGestRec)
      imageView.addGestureRecognizer(swipeLeftGestRec)
      
      swipeRightVisualEffect.direction = UISwipeGestureRecognizerDirection.right
      swipeLeftVisualEffect.direction = UISwipeGestureRecognizerDirection.left
      visualEffectView.addGestureRecognizer(swipeLeftVisualEffect)
      visualEffectView.addGestureRecognizer(swipeRightVisualEffect)
      
      swipeDownGestRec.direction = UISwipeGestureRecognizerDirection.down
      swipeDownVisualEffect.direction = UISwipeGestureRecognizerDirection.down
      imageView.addGestureRecognizer(swipeDownGestRec)
      visualEffectView.addGestureRecognizer(swipeDownVisualEffect)
        // Do any additional setup after loading the view.

    //      notification for the category of deal selected in the menu
//    NotificationCenter.default.addObserver(self,
//                                           selector: #selector(notificationReceived(_:)),
//                                           name: Notification.Name.deal,
//                                           object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    favSwitch.isHidden = false
    nextButton.isHidden = false
    
    self.visualEffectView.isHidden = true
    self.placeNameLabel.isHidden = true
//    self.blackMaskView.isHidden = false
    self.dealLabel.isHidden = true
    self.styleLabel.isHidden = true
    self.priceLabel.isHidden = true
    self.addressLabel.isHidden = true
    self.phoneLabel.isHidden = true
    self.daysAvailableLabel.isHidden = true
    self.favSwitch.isHidden = true
    
    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      favSwitch.isHidden = true
      nextButton.isHidden = true
      
      print("loaded dealvc with My Deals category selected")
      print(tempDealPlace.dealName + " at " + tempDealPlace.placeName + " available in dealvc")
      
      loadPhotoFromNetwork(imageUrl: tempDealPlace.dealImageUrl)
      
      placeNameLabel.text = tempDealPlace.placeName
      daysAvailableLabel.text = "Get it on " + tempDealPlace.dealDaysAvailable
      dealLabel.text = tempDealPlace.dealName
      styleLabel.text = tempDealPlace.dealStyle
      priceLabel.text = tempDealPlace.dealPrice
      addressLabel.text = tempDealPlace.placeAddress
      phoneLabel.text = tempDealPlace.placePhone
      
      placeCoordinateLatitude = tempDealPlace.placeLat
      placeCoordinateLongitude = tempDealPlace.placeLong
      placeName = tempDealPlace.placeName
    }
    self.view.layoutIfNeeded()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func loadPhotoFromNetwork(imageUrl: String) -> Void {
    let photoManager = PhotoManager()
    photoManager.photoNetworkRequest(url: imageUrl) { (image: UIImage) in
      
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    }
    
  }
//  @objc func notificationReceived(_ notification: Notification) {
//    guard let unwNotificationObj = notification.object else {
//      print("selected deal category error")
//      return
//    }
//
////    receiving notification for the category of deal selected
//    selectedDealCategory = String(describing: unwNotificationObj)
//    print(selectedDealCategory + " notification received")
//  }
  
  //MARK: Load Details on Screen
  fileprivate func applyFilter(_ filteredDealsList: inout [DealFirebase], category: String) {
    for deal in dealsList {
      if (deal.style?.contains(category))! {
        filteredDealsList.append(deal)
      }
    }
    print("filtered \(category) deals only")
  }
  
  func loadDetails() -> () {
    
    var filteredDealsList = [DealFirebase]()
    
    switch selectedDealCategory {
      
    case enumSelectedDealCategory.enumFoodDeals:
      applyFilter(&filteredDealsList, category: "Food")
      
//      fun category currently not available
    case enumSelectedDealCategory.enumFunDeals:
      applyFilter(&filteredDealsList, category: "Fun")

    case enumSelectedDealCategory.enumDrinkDeals:
      applyFilter(&filteredDealsList, category: "Drinks")

    case enumSelectedDealCategory.enumDateDeals:
      applyFilter(&filteredDealsList, category: "Date")
      
//      group category currently not available
    case enumSelectedDealCategory.enumGroupDeals:
      applyFilter(&filteredDealsList, category: "Group")

    default:
      
      //      dummy filter
      filteredDealsList = dealsList
    }
    
    let dealNumber = Int(arc4random_uniform(UInt32(filteredDealsList.count)))
    
    loadPhotoFromNetwork(imageUrl: filteredDealsList[dealNumber].img!)
    
//    potentially to be used to save deal for later if the user chooses to
    tempDealFirebase = filteredDealsList[dealNumber]
//    dealLabel.isHidden = false
    dealLabel.text = filteredDealsList[dealNumber].dealName
    priceLabel.text = filteredDealsList[dealNumber].price
    styleLabel.text = filteredDealsList[dealNumber].style
    daysAvailableLabel.text = "Get it on " + (filteredDealsList[dealNumber].daysAvalable)!
    
    for placeFB in placesList {
      if placeFB.placeID == filteredDealsList[dealNumber].placeid {
        
        //    potentially to be used to save deal for later if the user chooses to
        tempPlaceFirebase = placeFB
        
        addressLabel.text = placeFB.address
        placeNameLabel.text = placeFB.name
        phoneLabel.text = placeFB.phone
        guard let unwLatitude = placeFB.lat, let unwLongitude = placeFB.lon else {
          print("cannot unwrap lat long")
          return
        }
        
//        potentially to be used for mapview if user chooses to see on map
        placeCoordinateLatitude = unwLatitude
        placeCoordinateLongitude = unwLongitude
        
        guard let unwPlaceName = placeFB.name else {
          print("cannot unwrap place name")
          return
        }
        placeName = unwPlaceName
      }
    }
    
  }
  
  //DO NOT DELETE!!
  @IBAction func unwindToDealVC(segue:UIStoryboardSegue) {}
  
  //MARK: Swipe functionality
  @IBAction func swipedDownGestRec(_ sender: UISwipeGestureRecognizer) {
    
    if selectedDealCategory != enumSelectedDealCategory.enumMyDeals {
    
      favSwitch.isOn = true
    
      print("fav switch is on")
    
  //    UIView.transition(with: cardView, duration: 1.5, options: .transitionCurlDown, animations: nil) { (true) in
  //      self.nextButton.sendActions(for: .touchUpInside)
  //
  //    }
    
      UIView.animate(withDuration: 1.5, animations: {
        self.cardView.frame = CGRect(x: self.cardView.frame.origin.x, y: self.cardView.frame.origin.y + 1000.0, width: self.cardView.frame.size.width, height: self.cardView.frame.size.height)
      }) { (true) in
        self.nextButton.sendActions(for: .touchUpInside)

      }

      //      use data from temp Deal/Place Firebase objects for saving
      guard let unwDealName = tempDealFirebase.dealName,
        let unwDealImg = tempDealFirebase.img,
        let unwDealPlaceID = tempDealFirebase.placeid,
        let unwDealPrice = tempDealFirebase.price,
        let unwDealStyle = tempDealFirebase.style,
        let unwDealDaysAvailable = tempDealFirebase.daysAvalable,
        let unwPlaceName = tempPlaceFirebase.name,
        let unwPlaceAddress = tempPlaceFirebase.address,
        let unwPlaceLat = tempPlaceFirebase.lat,
        let unwPlaceLong = tempPlaceFirebase.lon,
        let unwPlaceID = tempPlaceFirebase.placeID,
        let unwPlacePhone = tempPlaceFirebase.phone
        else {
          print("cannot unwrap tempDealFirebase or tempPlaceFirebase properties")
          return
      }
    
      let dealPlace = DealPlace()
      dealPlace.dealFaved = true
      dealPlace.dealName = unwDealName
      dealPlace.dealImageUrl = unwDealImg
      dealPlace.placeID = unwDealPlaceID
      dealPlace.dealPrice = unwDealPrice
      dealPlace.dealStyle = unwDealStyle
      dealPlace.dealDaysAvailable = unwDealDaysAvailable
      dealPlace.placeName = unwPlaceName
      dealPlace.placePhone = unwPlacePhone
      dealPlace.placeAddress = unwPlaceAddress
      dealPlace.placeLat = unwPlaceLat
      dealPlace.placeLong = unwPlaceLong
    
      RealmManager.realmAdd(deal: dealPlace)
    }
  }
  
  @IBAction func swipedDownVisualEffect(_ sender: UISwipeGestureRecognizer) {
    
    if selectedDealCategory != enumSelectedDealCategory.enumMyDeals {
    
      favSwitch.isOn = true
    
      print("fav switch is on")

      //    UIView.transition(with: cardView, duration: 1.5, options: .transitionCurlDown, animations: nil) { (true) in
      //      self.nextButton.sendActions(for: .touchUpInside)
      //
      //    }
    
      UIView.animate(withDuration: 1.5, animations: {
        self.cardView.frame = CGRect(x: self.cardView.frame.origin.x, y: self.cardView.frame.origin.y + 1000.0, width: self.cardView.frame.size.width, height: self.cardView.frame.size.height)
      }) { (true) in
        self.nextButton.sendActions(for: .touchUpInside)
        
      }
    
      //      use data from temp Deal/Place Firebase objects for saving
      guard let unwDealName = tempDealFirebase.dealName,
        let unwDealImg = tempDealFirebase.img,
        let unwDealPlaceID = tempDealFirebase.placeid,
        let unwDealPrice = tempDealFirebase.price,
        let unwDealStyle = tempDealFirebase.style,
        let unwDealDaysAvailable = tempDealFirebase.daysAvalable,
        let unwPlaceName = tempPlaceFirebase.name,
        let unwPlaceAddress = tempPlaceFirebase.address,
        let unwPlaceLat = tempPlaceFirebase.lat,
        let unwPlaceLong = tempPlaceFirebase.lon,
        let unwPlaceID = tempPlaceFirebase.placeID,
        let unwPlacePhone = tempPlaceFirebase.phone
        else {
          print("cannot unwrap tempDealFirebase or tempPlaceFirebase properties")
          return
      }

      let dealPlace = DealPlace()
      dealPlace.dealFaved = true
      dealPlace.dealName = unwDealName
      dealPlace.dealImageUrl = unwDealImg
      dealPlace.placeID = unwDealPlaceID
      dealPlace.dealPrice = unwDealPrice
      dealPlace.dealStyle = unwDealStyle
      dealPlace.dealDaysAvailable = unwDealDaysAvailable
      dealPlace.placeName = unwPlaceName
      dealPlace.placePhone = unwPlacePhone
      dealPlace.placeAddress = unwPlaceAddress
      dealPlace.placeLat = unwPlaceLat
      dealPlace.placeLong = unwPlaceLong

      RealmManager.realmAdd(deal: dealPlace)
    }
  }
  
  
//  swiped left on the backside of the card
  @IBAction func swipedLeftVisualEffect(_ sender: UISwipeGestureRecognizer) {
//    visualEffectView.isHidden = true
    
    UIView.transition(with: cardView, duration: 1.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    self.visualEffectView.isHidden = true
    self.placeNameLabel.isHidden = true
    //          self.blackMaskView.isHidden = true
    self.dealLabel.isHidden = true
    self.styleLabel.isHidden = true
    self.priceLabel.isHidden = true
    self.addressLabel.isHidden = true
    self.phoneLabel.isHidden = true
    self.daysAvailableLabel.isHidden = true
    self.favSwitch.isHidden = true

  }
  
//  swiped right on the backside of the card
  @IBAction func swipedRightVisualEffect(_ sender: UISwipeGestureRecognizer) {
//    visualEffectView.isHidden = true
    
    UIView.transition(with: cardView, duration: 1.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    self.visualEffectView.isHidden = true
    self.placeNameLabel.isHidden = true
    //          self.blackMaskView.isHidden = true
    self.dealLabel.isHidden = true
    self.styleLabel.isHidden = true
    self.priceLabel.isHidden = true
    self.addressLabel.isHidden = true
    self.phoneLabel.isHidden = true
    self.daysAvailableLabel.isHidden = true
    self.favSwitch.isHidden = true
  }
  
  @IBAction func swipeLeftGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped left")
    favSwitch.isOn = false
    
//      loadDetails()
//    }
    UIView.transition(with: cardView, duration: 1.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    self.visualEffectView.isHidden = false
    self.placeNameLabel.isHidden = false
    //          self.blackMaskView.isHidden = true
    self.dealLabel.isHidden = false
    self.styleLabel.isHidden = false
    self.priceLabel.isHidden = false
    self.addressLabel.isHidden = false
    self.phoneLabel.isHidden = false
    self.daysAvailableLabel.isHidden = false
    
    if selectedDealCategory != enumSelectedDealCategory.enumMyDeals {

      self.favSwitch.isHidden = false
    }
  }
  @IBAction func swipeRightGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped right")
    favSwitch.isOn = false
    
//    if selectedDealCategory != enumSelectedDealCategory.enumMyDeals {
//      loadDetails()
//      let option: UIViewAnimationOptions = .transitionFlipFromLeft
      
//      if (isFrontVisible) {
//        isFrontVisible = false
    
// multiple spins
//      UIView.transition(with: cardView, duration: 0.75, options: [.transitionFlipFromLeft,.repeat], animations: nil, completion: nil)
//
//      let delayTime = DispatchTime.now() + 1.4
//      DispatchQueue.main.asyncAfter(deadline: delayTime) {
//        self.cardView.layer.removeAllAnimations()
//      }
//        UIView.transition(with: cardView, duration: 1.5, options: .transitionFlipFromLeft, animations: nil) { (NULL) in
    UIView.transition(with: cardView, duration: 1.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    self.visualEffectView.isHidden = false
    self.placeNameLabel.isHidden = false
//          self.blackMaskView.isHidden = true
    self.dealLabel.isHidden = false
    self.styleLabel.isHidden = false
    self.priceLabel.isHidden = false
    self.addressLabel.isHidden = false
    self.phoneLabel.isHidden = false
    self.daysAvailableLabel.isHidden = false
    
    if selectedDealCategory != enumSelectedDealCategory.enumMyDeals {
      
      self.favSwitch.isHidden = false
    }

//        }
//      } else {
//        isFrontVisible = true
    
//        self.visualEffectView.isHidden = true
//        self.placeNameLabel.isHidden = true
////        self.blackMaskView.isHidden = false
//        self.dealLabel.isHidden = true
//        self.styleLabel.isHidden = true
//        self.priceLabel.isHidden = true
//        self.addressLabel.isHidden = true
//        self.phoneLabel.isHidden = true
//        self.daysAvailableLabel.isHidden = true
//        self.favSwitch.isHidden = true

//      }
//    }
    
    
  }
  
  @IBAction func nextDealButton(_ sender: Any) {
    favSwitch.isOn = false
    
    print(selectedDealCategory)
    
    print("count of deals " + String(describing: dealsList.count))
    print("count of places " + String(describing: placesList.count))

    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      print("my deals")
    }
    
    loadDetails()

    self.view.layoutIfNeeded()
  }
  
  @IBAction func shareButton(_ sender: UIBarButtonItem) {
    print("share tapped")
    
    guard let unwPlace = placeNameLabel.text,
      let unwAddress = addressLabel.text,
      let unwDeal = dealLabel.text else {
        return
    }
    
//    set a string containing place, address, deal for sharing
    let activityViewController = UIActivityViewController(activityItems: ["Would you like to go to \(String(describing: unwPlace)), \(String(describing: unwAddress)), for \(String(describing: unwDeal))?"],
      applicationActivities: nil)
    
//    open sharing options
    activityViewController.popoverPresentationController?.sourceView = self.view
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  //MARK: Favourite switch
  @IBAction func favSwitch(_ sender: UISwitch) {
    //BUG: In one case, saving the same deal twice saves a different deal the second time
    if sender.isOn == true {
      print("fav switch is on")

      //      use data from temp Deal/Place Firebase objects for saving
      guard let unwDealName = tempDealFirebase.dealName,
        let unwDealImg = tempDealFirebase.img,
        let unwDealPlaceID = tempDealFirebase.placeid,
        let unwDealPrice = tempDealFirebase.price,
        let unwDealStyle = tempDealFirebase.style,
        let unwDealDaysAvailable = tempDealFirebase.daysAvalable,
        let unwPlaceName = tempPlaceFirebase.name,
        let unwPlaceAddress = tempPlaceFirebase.address,
        let unwPlaceLat = tempPlaceFirebase.lat,
        let unwPlaceLong = tempPlaceFirebase.lon,
        let unwPlaceID = tempPlaceFirebase.placeID,
        let unwPlacePhone = tempPlaceFirebase.phone
      else {
        print("cannot unwrap tempDealFirebase or tempPlaceFirebase properties")
        return
      }
      
      let dealPlace = DealPlace()
      dealPlace.dealFaved = true
      dealPlace.dealName = unwDealName
      dealPlace.dealImageUrl = unwDealImg
      dealPlace.placeID = unwDealPlaceID
      dealPlace.dealPrice = unwDealPrice
      dealPlace.dealStyle = unwDealStyle
      dealPlace.dealDaysAvailable = unwDealDaysAvailable
      dealPlace.placeName = unwPlaceName
      dealPlace.placePhone = unwPlacePhone
      dealPlace.placeAddress = unwPlaceAddress
      dealPlace.placeLat = unwPlaceLat
      dealPlace.placeLong = unwPlaceLong
      
      RealmManager.realmAdd(deal: dealPlace)
      
    } else {
      
      print("fav switch is off")
      
//      delete from realm if user turn switch off
      guard let unwDealName = dealLabel.text else {
        return
      }
      
      let dealPlace = DealPlace()
      dealPlace.dealFaved = false
      dealPlace.dealName = unwDealName

      RealmManager.realmDelete(unwDealName, dealPlace)
      
    }
  }
  
//  deinit {
//
////    removing observer from notification
//        NotificationCenter.default.removeObserver(self,
//                                                  name: Notification.Name.deal,
//                                                  object: nil)
//  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "segueToMapView" {
      
      let mapVC = segue.destination as! MapViewController
      
      guard let unwPlaceCoordinateLatitude = placeCoordinateLatitude, let unwPlaceCoordinateLongitude = placeCoordinateLongitude else {
        print("cannot unwrap lat long")
        return
      }
      mapVC.placeCoordinateLatitude = (unwPlaceCoordinateLatitude as NSString).doubleValue
      mapVC.placeCoordinateLongitude = (unwPlaceCoordinateLongitude as NSString).doubleValue
      
      mapVC.placeName = placeName
    }
  }
}
