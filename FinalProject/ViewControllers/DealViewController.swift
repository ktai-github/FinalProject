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
  @IBOutlet weak var daysAvailable: UILabel!
  
  
  var selectedDealCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  var dealsData = [Any]()
  var placesData = [Any]()
  
  var ref: DatabaseReference!
  var refHandle: UInt!
  var dealsList = [DealFirebase]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      ref = Database.database().reference()
      
      fetchDeals()
      
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
    refHandle = ref.child("deals").observe(DataEventType.childAdded, with: { (snapshot) in
      
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
    dealLabel.text = dealsList[0].dealName
    priceLabel.text = dealsList[0].price
    styleLabel.text = dealsList[0].style?.joined(separator: ", ")
    daysAvailable.text = "Get it on " + (dealsList[0].daysAvalable?.joined(separator: ", "))!
    
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
//    print(dealsData)
//    print(placesData)
//    print("printed dealsdata count = " + String(describing: dealsData.count))
//    print("printed placesdata count = " + String(describing: placesData.count))
    print("count of deals " + String(describing: dealsList.count))

    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      print("my deals")
    }
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
