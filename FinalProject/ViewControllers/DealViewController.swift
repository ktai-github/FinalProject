//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//
// BUG: L'abboir brunch deal will crash the app if delete from My Deals

import UIKit

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
  
  @IBOutlet weak var blackMaskView: UIView!
  @IBOutlet weak var dealLabel: UILabel!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var styleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var daysAvailableLabel: UILabel!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var showMapButton: UIButton!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var swipeView: UIView!
  @IBOutlet weak var loadingLabel: UILabel!
  
  var selectedDealCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  var placeName: String?

  var placeCoordinates: (placeLong: String?,
                          placeLat: String?)
  
  var tempDealFirebase = DealFirebase()
  var tempPlaceFirebase = PlaceFirebase()
  
//  DealPace is used to combine deal and place data when user saves it
//  Combining deal and place data is done to persist data on Realm
  var tempDealPlace = DealPlace()
  
  // MARK: - View Controller Life Cycle
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
      
    setUpGestureRecognizers()

//      notification for the category of deal selected in the menu
//    NotificationCenter.default.addObserver(self,
//                                           selector: #selector(notificationReceived(_:)),
//                                           name: Notification.Name.deal,
//                                           object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    
    setUpViewsInViewWillAppear()
    
    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      
//      disable next button if showing deals in My Deals
      nextButton.isHidden = true
      
      print("loaded dealvc with My Deals category selected")
      print(tempDealPlace.dealName + " at " + tempDealPlace.placeName + " available in dealvc")
      
      loadPhotoFromNetwork(imageUrl: tempDealPlace.dealImageUrl)
      
      setUpLabels()
      
//      prepare coordinates and annotation to appear map if the user taps Show Map
      prepareCoordinatesAndAnno()
      
//    selected a filter category
    } else if selectedDealCategory == enumSelectedDealCategory.enumDrinkDeals ||
      selectedDealCategory == enumSelectedDealCategory.enumDateDeals ||
      selectedDealCategory == enumSelectedDealCategory.enumFoodDeals
      {
      
//      show the next deal without user tapping next deal button for ease of use
      nextDealButton((Any).self)

    }
    self.view.layoutIfNeeded()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
  
  //DO NOT DELETE!!
  @IBAction func unwindToDealVC(segue:UIStoryboardSegue) {}
  
//MARK: - Swipe Procedures
  
//  swiped down on the front side of the card
  @IBAction func swipedDownGestRec(_ sender: UISwipeGestureRecognizer) {
    
    saveForLater()
    
  }
  
//  swiped down on the back side of the card
  @IBAction func swipedDownVisualEffect(_ sender: UISwipeGestureRecognizer) {

    saveForLater()
    
  }
  
//  swiped left on the back side of the card
  @IBAction func swipedLeftVisualEffect(_ sender: UISwipeGestureRecognizer) {
    
    flipCardFromBackToFront(direction: UIViewAnimationOptions.transitionFlipFromRight)
    
  }
  
//  swiped right on the back side of the card
  @IBAction func swipedRightVisualEffect(_ sender: UISwipeGestureRecognizer) {

    flipCardFromBackToFront(direction: UIViewAnimationOptions.transitionFlipFromLeft)

  }
  
//  swiped left on the front side of the card
  @IBAction func swipeLeftGestRec(_ sender: UISwipeGestureRecognizer) {
    
    flipCardFromFrontToBack(direction: UIViewAnimationOptions.transitionFlipFromRight)
    
  }
  
//  swiped right on the front side of the card
  @IBAction func swipeRightGestRec(_ sender: UISwipeGestureRecognizer) {
    
    flipCardFromFrontToBack(direction: UIViewAnimationOptions.transitionFlipFromLeft)
    
  }
  
//  MARK: - Button Functions
  
  @IBAction func nextDealButton(_ sender: Any) {
    
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
      
      guard case placeCoordinates.placeLat = placeCoordinates.placeLat, case placeCoordinates.placeLong = placeCoordinates.placeLong else {
        print("cannot unwrap lat long")
        return
      }

      mapVC.placeCoordinates.placeLat = (placeCoordinates.placeLat! as NSString).doubleValue
      mapVC.placeCoordinates.placeLong = (placeCoordinates.placeLong! as NSString).doubleValue
      
      mapVC.placeName = placeName
    }
  }

//  MARK: - Gesture Refactored

  fileprivate func setUpGestureRecognizers() {

//    arrays of gesture recognizers must be order of right, left, down
//    swipe gesture recognizers for the image view with no black mask
    let gestureRecognizersNormalView: [UISwipeGestureRecognizer] =
      [swipeRightGestRec, swipeLeftGestRec, swipeDownGestRec]
    
    addDirections(toRecognizers: gestureRecognizersNormalView)
    addGesture(recognizers: gestureRecognizersNormalView, toView: imageView)

//    swipe gesture recognizers for the view with black mask
    let gestureRecognizersVisualEffect: [UISwipeGestureRecognizer] =
      [swipeRightVisualEffect, swipeLeftVisualEffect, swipeDownVisualEffect]
    
    addDirections(toRecognizers: gestureRecognizersVisualEffect)
    addGesture(recognizers: gestureRecognizersVisualEffect, toView: swipeView)
    
  }
  
//  rely on arrays of gesture recognizers in order of right, left, down
  fileprivate func addDirections(toRecognizers: [UISwipeGestureRecognizer]) {
    toRecognizers[0].direction = UISwipeGestureRecognizerDirection.right
    toRecognizers[1].direction = UISwipeGestureRecognizerDirection.left
    toRecognizers[2].direction = UISwipeGestureRecognizerDirection.down
  }
  
  fileprivate func addGesture(recognizers: [UIGestureRecognizer], toView: UIView) {
    for recognizer in recognizers {
      toView.addGestureRecognizer(recognizer)
    }
  }
  
//  MARK: - ViewWillAppear Refactored
  
  fileprivate func setUpViewsInViewWillAppear() {
    nextButton.isHidden = false
    
    self.blackMaskView.isHidden = true
    self.placeNameLabel.isHidden = true
    self.dealLabel.isHidden = true
    self.styleLabel.isHidden = true
    self.priceLabel.isHidden = true
    self.addressLabel.isHidden = true
    self.phoneLabel.isHidden = true
    self.daysAvailableLabel.isHidden = true
    self.showMapButton.isHidden = true
    self.stackView.isHidden = true
    self.swipeView.isHidden = true
  }
  
  func loadPhotoFromNetwork(imageUrl: String) -> Void {
    let photoManager = PhotoManager()
    photoManager.photoNetworkRequest(url: imageUrl) { (image: UIImage) in
      
      DispatchQueue.main.async {
        self.imageView.image = image
        self.loadingLabel.isHidden = true
      }
    }
    
  }
  
  fileprivate func setUpLabels() {
    placeNameLabel.text = tempDealPlace.placeName
    daysAvailableLabel.text = tempDealPlace.dealDaysAvailable
    dealLabel.text = tempDealPlace.dealName
    styleLabel.text = tempDealPlace.dealStyle
    priceLabel.text = tempDealPlace.dealPrice
    addressLabel.text = tempDealPlace.placeAddress
    phoneLabel.text = tempDealPlace.placePhone
  }
  
  fileprivate func prepareCoordinatesAndAnno() {
    placeCoordinates.placeLat = tempDealPlace.placeLat
    placeCoordinates.placeLong = tempDealPlace.placeLong
    placeName = tempDealPlace.placeName
  }
  
  //MARK: - Swipe Procedures Refactored
  
  fileprivate func saveForLater() {
    if selectedDealCategory != enumSelectedDealCategory.enumMyDeals {
      
      print("fav switch is on")
      
      //    slower animation for presentation
      //    UIView.transition(with: cardView, duration: 1.5, options: .transitionCurlDown, animations: nil) { (true) in
      //      self.nextButton.sendActions(for: .touchUpInside)
      //
      //    }
      
      UIView.animate(withDuration: 0.5, animations: {
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
//        let unwPlaceID = tempPlaceFirebase.placeID,
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
      
      RealmManager.realmAdd(dealPlace: dealPlace)
    }
  }
  
  fileprivate func flipCardFromBackToFront(direction: UIViewAnimationOptions) {

    UIView.transition(with: cardView, duration: 0.5, options: direction, animations: nil, completion: nil)

    self.blackMaskView.isHidden = true
    self.placeNameLabel.isHidden = true
    self.dealLabel.isHidden = true
    self.styleLabel.isHidden = true
    self.priceLabel.isHidden = true
    self.addressLabel.isHidden = true
    self.phoneLabel.isHidden = true
    self.daysAvailableLabel.isHidden = true
    self.showMapButton.isHidden = true
    self.stackView.isHidden = true
    self.swipeView.isHidden = true
  }
  
  fileprivate func flipCardFromFrontToBack(direction: UIViewAnimationOptions) {

    UIView.transition(with: cardView, duration: 0.5, options: direction, animations: nil, completion: nil)
    
    self.blackMaskView.isHidden = false
    self.placeNameLabel.isHidden = false
    self.dealLabel.isHidden = false
    self.styleLabel.isHidden = false
    self.priceLabel.isHidden = false
    self.addressLabel.isHidden = false
    self.phoneLabel.isHidden = false
    self.daysAvailableLabel.isHidden = false
    self.showMapButton.isHidden = false
    self.stackView.isHidden = false
    self.swipeView.isHidden = false
  }
  
//  MARK: - Next Button Refactored
  
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
      //    case enumSelectedDealCategory.enumFunDeals:
      //      applyFilter(&filteredDealsList, category: "Fun")
      
    case enumSelectedDealCategory.enumDrinkDeals:
      applyFilter(&filteredDealsList, category: "Drinks")
      
    case enumSelectedDealCategory.enumDateDeals:
      applyFilter(&filteredDealsList, category: "Date")
      
      //      group category currently not available
      //    case enumSelectedDealCategory.enumGroupDeals:
      //      applyFilter(&filteredDealsList, category: "Group")
      
    default:
      
      //      dummy filter
      filteredDealsList = dealsList
    }
    
    var dealNumber: Int
    
    dealNumber = Int(arc4random_uniform(UInt32(filteredDealsList.count)))
    
    loadPhotoFromNetwork(imageUrl: filteredDealsList[dealNumber].img!)
    
    //    potentially to be used to save deal for later if the user chooses to
    tempDealFirebase = filteredDealsList[dealNumber]
    
    dealLabel.text = filteredDealsList[dealNumber].dealName
    priceLabel.text = filteredDealsList[dealNumber].price
    styleLabel.text = filteredDealsList[dealNumber].style
    daysAvailableLabel.text = filteredDealsList[dealNumber].daysAvalable
    
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
        placeCoordinates.placeLat = unwLatitude
        placeCoordinates.placeLong = unwLongitude
        
        guard let unwPlaceName = placeFB.name else {
          print("cannot unwrap place name")
          return
        }
        placeName = unwPlaceName
      }
    }
    
  }
}
