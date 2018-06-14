//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//
// BUG: L'abboir brunch deal will crash the app if delete from My Deals

import UIKit

enum enumSelectedDealCategory {
  case enumRandomDeals
  case enumFoodDeals
  case enumDrinkDeals
  case enumDateDeals
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
        self.loadDetails()
    }
      
    setUpGestureRecognizers()

  }

  override func viewWillAppear(_ animated: Bool) {
    
    setUpViews()
    
    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      
//      disable next button if showing deals in My Deals
      nextButton.isHidden = true
      
      print("loaded dealvc with My Deals category selected")
      print(tempDealPlace.dealName + " at " + tempDealPlace.placeName + " available in dealvc")

//      DispatchQueue.global(qos: .userInitiated).async { [unowned self] in

        self.loadPhotoFromNetwork(imageUrl: self.tempDealPlace.dealImageUrl)
      
//      }
      
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
    
    flipCard(direction: UIViewAnimationOptions.transitionFlipFromRight, backSideToFrontSide: true)
    
  }
  
//  swiped right on the back side of the card
  @IBAction func swipedRightVisualEffect(_ sender: UISwipeGestureRecognizer) {

    flipCard(direction: UIViewAnimationOptions.transitionFlipFromLeft, backSideToFrontSide: true)

  }
  
//  swiped left on the front side of the card
  @IBAction func swipeLeftGestRec(_ sender: UISwipeGestureRecognizer) {
    
    flipCard(direction: UIViewAnimationOptions.transitionFlipFromRight, backSideToFrontSide: false)
    
  }
  
//  swiped right on the front side of the card
  @IBAction func swipeRightGestRec(_ sender: UISwipeGestureRecognizer) {
    
    flipCard(direction: UIViewAnimationOptions.transitionFlipFromLeft, backSideToFrontSide: false)
    
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
  
  fileprivate func detailViews(hide: Bool) {
    self.blackMaskView.isHidden = hide
    self.placeNameLabel.isHidden = hide
    self.dealLabel.isHidden = hide
    self.styleLabel.isHidden = hide
    self.priceLabel.isHidden = hide
    self.addressLabel.isHidden = hide
    self.phoneLabel.isHidden = hide
    self.daysAvailableLabel.isHidden = hide
    self.showMapButton.isHidden = hide
    self.stackView.isHidden = hide
    self.swipeView.isHidden = hide
  }

  fileprivate func setUpViews() {
    nextButton.isHidden = false

    detailViews(hide: true)
  }
  
  func loadPhotoFromNetwork(imageUrl: String) -> Void {
    let photoManager = PhotoManager()
//    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in

      photoManager.photoNetworkRequest(url: imageUrl) { [unowned self] (image: UIImage) in
      
//        DispatchQueue.main.async { [unowned self] in
          self.imageView.image = image
          self.loadingLabel.isHidden = true
//        }
      }
//    }
    
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
  
  fileprivate func flipCard(direction: UIViewAnimationOptions, backSideToFrontSide: Bool) {

    UIView.transition(with: cardView, duration: 0.5, options: direction, animations: nil, completion: nil)
    
    if backSideToFrontSide == true {
      
      detailViews(hide: true)  // no details shown

    } else {
      
      detailViews(hide: false)  // show details
    }
  }
  
//  MARK: - Next Button Refactored
  
//  Parameters in swift is constant by default
//  Parameter can mutate in the function if it is specified as inout variable
  fileprivate func applyFilter(category: String) -> ([DealFirebase]) {
    
    var filteredDealsList = [DealFirebase]()
    
    for deal in dealsList {

      if (deal.style?.contains(category))! {
        filteredDealsList.append(deal)
      }
    }

    print("filtered \(category) deals only")

    return filteredDealsList
  }
  
  func loadDetails() -> () {

    var outputDealsList = [DealFirebase]()
    
    switch self.selectedDealCategory {
      
    case enumSelectedDealCategory.enumFoodDeals:
      outputDealsList = self.applyFilter(category: "Food")
      
    case enumSelectedDealCategory.enumDrinkDeals:
      outputDealsList = self.applyFilter(category: "Drinks")

    case enumSelectedDealCategory.enumDateDeals:
      outputDealsList = self.applyFilter(category: "Date")

    default:
      
      //      dummy filter
      outputDealsList = dealsList
    }
    
    var dealNumber: Int
    
    dealNumber = Int(arc4random_uniform(UInt32(outputDealsList.count)))
    
//    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in

      self.loadPhotoFromNetwork(imageUrl: outputDealsList[dealNumber].img!)
      
//      DispatchQueue.main.async { [unowned self] in

        //    potentially to be used to save deal for later if the user chooses to
        self.tempDealFirebase = outputDealsList[dealNumber]
      
        self.dealLabel.text = outputDealsList[dealNumber].dealName
        self.priceLabel.text = outputDealsList[dealNumber].price
        self.styleLabel.text = outputDealsList[dealNumber].style
        self.daysAvailableLabel.text = outputDealsList[dealNumber].daysAvalable
//      }
//    }
    for placeFB in placesList {
      if placeFB.placeID == outputDealsList[dealNumber].placeid {
        
        //    potentially to be used to save deal for later if the user chooses to
        self.tempPlaceFirebase = placeFB
        
        self.addressLabel.text = placeFB.address
        self.placeNameLabel.text = placeFB.name
        self.phoneLabel.text = placeFB.phone

        guard let unwLatitude = placeFB.lat, let unwLongitude = placeFB.lon else {
          print("cannot unwrap lat long")
          return
        }
        
        //        potentially to be used for mapview if user chooses to see on map
        self.placeCoordinates.placeLat = unwLatitude
        self.placeCoordinates.placeLong = unwLongitude
        
        guard let unwPlaceName = placeFB.name else {
          print("cannot unwrap place name")
          return
        }
        self.placeName = unwPlaceName
      }
    }
  }
}
