//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import FirebaseDatabase
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

class DealViewController: UIViewController {

  @IBOutlet var swipeLeftGestRec: UISwipeGestureRecognizer!
  @IBOutlet var swipeRightGestRec: UISwipeGestureRecognizer!
  
  @IBOutlet weak var favSwitch: UISwitch!
  @IBOutlet weak var blackMaskView: UIView!
  @IBOutlet weak var dealLabel: UILabel!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var styleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var daysAvailableLabel: UILabel!
  
  
  var selectedDealCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  var ref: DatabaseReference!
  var refHandle: UInt!

  var dealsList = [DealFirebase]()
  var placesList = [PlaceFirebase]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      ref = Database.database().reference()

      fetchDeals()
      fetchPlaces()
//      FirebaseManager.defaultManager.fetchDeals()
//      FirebaseManager.defaultManager.fetchPlaces()

//      FirebaseManager.defaultManager.loadFromFirebase(node: "deals") { (actualSubnode: Any) in
//        self.dealsData.append(actualSubnode)
//        print(actualSubnode)
//        print("added actualsubnode")
//      }
//
//      FirebaseManager.defaultManager.loadFromFirebase(node: "places") { (actualSubnode: Any) in
//        self.placesData.append(actualSubnode)
//        print(actualSubnode)
//        print("added actualsubnode")
//      }
      

//      recognize swiping left and right
      swipeRightGestRec.direction = UISwipeGestureRecognizerDirection.right
      swipeLeftGestRec.direction = UISwipeGestureRecognizerDirection.left
      blackMaskView.addGestureRecognizer(swipeRightGestRec)
      blackMaskView.addGestureRecognizer(swipeLeftGestRec)
      
        // Do any additional setup after loading the view.

    //      notification for the category of deal selected in the menu
//    NotificationCenter.default.addObserver(self,
//                                           selector: #selector(notificationReceived(_:)),
//                                           name: Notification.Name.deal,
//                                           object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      favSwitch.isHidden = true
    } else {
      favSwitch.isHidden = false
    }
    self.view.layoutIfNeeded()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func fetchDeals() {
    refHandle = ref.child("deals").observe(DataEventType.childAdded, with: { [unowned self] (snapshot) in

      if let dictionary = snapshot.value as? [String: Any] {
        var dealFirebase = DealFirebase()
        dealFirebase.dealName = dictionary["dealName"] as? String
        print("printing dealFirebase.dealname " + dealFirebase.dealName!)
        dealFirebase.img = dictionary["img"] as? String
        print("printing dealFirebase.img " + dealFirebase.img!)
        dealFirebase.placeid = dictionary["placeid"] as? String
        print("printing dealFirebase.placeid " + dealFirebase.placeid!)
        dealFirebase.price = dictionary["price"] as? String
        print("printing dealFirebase.price " + dealFirebase.price!)
        dealFirebase.style = dictionary["style"] as? [String]
        print("printing dealFirebase.style " + dealFirebase.style!.joined(separator: ", "))
        dealFirebase.daysAvalable = dictionary["daysAvalable"] as? [String]
        print("printing dealFirebase.daysAvalable " + dealFirebase.daysAvalable!.joined(separator: ", "))

        self.dealsList.append(dealFirebase)

      }
    })
  }

  func fetchPlaces() {
    refHandle = ref.child("places").observe(DataEventType.childAdded, with: { [unowned self] (snapshot) in

      if let dictionary = snapshot.value as? [String: Any] {
        var placeFirebase = PlaceFirebase()
        placeFirebase.address = dictionary["address"] as? String
        print("printing placeFirebase.address " + placeFirebase.address!)
        placeFirebase.lat = dictionary["lat"] as? String
        print("printing placeFirebase.lat " + placeFirebase.lat!)
        placeFirebase.lon = dictionary["lon"] as? String
        print("printing placeFirebase.lon " + placeFirebase.lon!)
        placeFirebase.name = dictionary["name"] as? String
        print("printing placeFirebase.name " + placeFirebase.name!)
        placeFirebase.phone = dictionary["phone"] as? String
        print("printing placeFirebase.phone " + placeFirebase.phone!)
        placeFirebase.placeID = dictionary["placeID"] as? String
        print("printing placeFirebase.placeID " + placeFirebase.placeID!)

        self.placesList.append(placeFirebase)

      }
    })
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
  
  func loadDetails() -> () {
    
    let dealNumber = Int(arc4random_uniform(UInt32(dealsList.count)))
    
    loadPhotoFromNetwork(imageUrl: dealsList[dealNumber].img!)
    
    dealLabel.text = dealsList[dealNumber].dealName
    priceLabel.text = dealsList[dealNumber].price
    styleLabel.text = dealsList[dealNumber].style?.joined(separator: ", ")
    daysAvailableLabel.text = "Get it on " + (dealsList[dealNumber].daysAvalable?.joined(separator: ", "))!
    
    for placeFB in placesList {
      if placeFB.placeID == dealsList[dealNumber].placeid {
        addressLabel.text = placeFB.address
        placeNameLabel.text = placeFB.name
        phoneLabel.text = placeFB.phone
      }
    }
    
  }
  
  @IBAction func unwindToDealVC(segue:UIStoryboardSegue) {}
  
  @IBAction func swipeLeftGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped left")
    loadDetails()
  }
  @IBAction func swipeRightGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped right")
    loadDetails()
  }
  
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
  
  @IBAction func favSwitch(_ sender: UISwitch) {
    
    if sender.isOn == true {
      print("fav switch is on")
      guard let unwDealName = dealLabel.text else {
        return
      }
      
      let deal = Deal()
      deal.dealFaved = true
      deal.dealName = unwDealName
      deal.dealID = 100
      deal.dealImageUrl = "http://whatever.com/whatever.jpg"
      deal.placeID = 1000
      deal.price = "$10"
      deal.styleID = 4
      deal.tags = "sightseeing"
      
      RealmManager.realmAdd(deal: deal)
      
    } else {
      print("fav switch is off")
      guard let unwDealName = dealLabel.text else {
        return
      }
      
      let deal = Deal()
      deal.dealFaved = false
      deal.dealName = unwDealName

      RealmManager.realmDelete(unwDealName, deal)
      
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

}
