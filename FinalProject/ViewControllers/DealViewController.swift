//
//  DealViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit

extension Notification.Name {
  static let deal: Notification.Name = Notification.Name("deal")
}

class DealViewController: UIViewController {

  @IBOutlet var swipeLeftGestRec: UISwipeGestureRecognizer!
  @IBOutlet var swipeRightGestRec: UISwipeGestureRecognizer!
  
  @IBOutlet weak var imageView: UIImageView!
  
  var selectedDealCategory: String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(notificationReceived(_:)),
                                             name: Notification.Name.deal,
                                             object: nil)
      swipeRightGestRec.direction = .right
      swipeLeftGestRec.direction = .left
      imageView.addGestureRecognizer(swipeRightGestRec)
      imageView.addGestureRecognizer(swipeLeftGestRec)

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
  
  
  deinit {
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
