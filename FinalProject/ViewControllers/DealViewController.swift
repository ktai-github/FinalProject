//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit

// notification for the category of deal selected in the menu
extension Notification.Name {
  static let deal: Notification.Name = Notification.Name("deal")
}

class DealViewController: UIViewController {

  @IBOutlet var swipeLeftGestRec: UISwipeGestureRecognizer!
  @IBOutlet var swipeRightGestRec: UISwipeGestureRecognizer!
  
  @IBOutlet weak var blackMaskView: UIView!
  @IBOutlet weak var dealLabel: UILabel!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var styleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  
  var selectedDealCategory: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
      
//      notification for the category of deal selected in the menu
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(notificationReceived(_:)),
                                             name: Notification.Name.deal,
                                             object: nil)
      
//      recognize swiping left and right
      swipeRightGestRec.direction = .right
      swipeLeftGestRec.direction = .left
      blackMaskView.addGestureRecognizer(swipeRightGestRec)
      blackMaskView.addGestureRecognizer(swipeLeftGestRec)
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @objc func notificationReceived(_ notification: Notification) {
    guard let unwNotificationObj = notification.object else {
      print("selected deal category error")
      return
    }
    
//    receiving notification for the category of deal selected
    selectedDealCategory = String(describing: unwNotificationObj)
    print(selectedDealCategory + " notification received")
  }
  
  @IBAction func swipeLeftGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped left")
  }
  @IBAction func swipeRightGestRec(_ sender: UISwipeGestureRecognizer) {
    print("swiped right")
  }
  
  @IBAction func nextDealButton(_ sender: Any) {
    if selectedDealCategory == "my deals" {
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
  
  deinit {
//    removing observer from notification
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.deal,
                                                  object: nil)
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
