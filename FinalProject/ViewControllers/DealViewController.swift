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

//  var selectedMenuItem: String = ""
  

    override func viewDidLoad() {
        super.viewDidLoad()
//      NotificationCenter.default.post(name: Notification.Name(rawValue: "random"), object: randomSelected)
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(notificationReceived(_:)),
                                             name: Notification.Name.deal,
                                             object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @objc func notificationReceived(_ notification: Notification) {
    guard let selectedDealCategory = notification.object else {
      print("selected deal category error")
      return
    }
    print(String(describing: selectedDealCategory) + " notification received")
  }
  
  deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.deal,
                                                  object: nil)
  }

//  extension Notification.Name {
//    static let randomMenuItem = Notification.Name("random")
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
