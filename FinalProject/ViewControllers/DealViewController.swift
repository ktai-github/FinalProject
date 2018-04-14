//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
//import Firebase
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
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  
  var selectedDealCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
//      recognize swiping left and right
      swipeRightGestRec.direction = UISwipeGestureRecognizerDirection.right
      swipeLeftGestRec.direction = UISwipeGestureRecognizerDirection.left
      blackMaskView.addGestureRecognizer(swipeRightGestRec)
      blackMaskView.addGestureRecognizer(swipeLeftGestRec)
      
//      
      
//      retrieve the posts and listen for changes
      databaseHandle = ref?.child("deals").observe(.childAdded, with: { (snapshot) in
//        code to execute when child is added under deals
//        take the value from the snapshot and added it to the dealsdata array
//        let deal = snapshot.value as? String
        if let actualDeal = snapshot.value {
          self.dealsData.append(actualDeal)
//          print(actualDeal)
        }

      })
      

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
  
  @IBAction func unwindToDealVC(segue:UIStoryboardSegue) {}
  
  @IBAction func swipeLeftGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped left")
  }
  @IBAction func swipeRightGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped right")
  }
  
  @IBAction func nextDealButton(_ sender: Any) {
    print(selectedDealCategory)
    print(dealsData)
    if selectedDealCategory == enumSelectedDealCategory.enumMyDeals {
      print("my deals")
    }
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
