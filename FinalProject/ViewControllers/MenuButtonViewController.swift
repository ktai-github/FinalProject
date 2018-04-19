//
//  MenuButtonViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-19.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit
import RealmSwift

class MenuButtonViewController: UIViewController {

  var userSelectedCategory: enumSelectedDealCategory = enumSelectedDealCategory.enumRandomDeals

  
  //  navigate to deal vc with the category that was selected for filtering deals
  func userSelected(category: enumSelectedDealCategory) {
    userSelectedCategory = category
    //    NotificationCenter.default.post(name: Notification.Name.deal,
    //                                    object: userSelectedCategory)
    //    self.navigationController?.popViewController(animated: true)
    performSegue(withIdentifier: "unwindSegueFromMenuToDealVC", sender: self)
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func randomDealsTapped(_ sender: UIButton) {
    print("random deals selected")
    userSelected(category: enumSelectedDealCategory.enumRandomDeals)

  }
  
  @IBAction func foodDealsTapped(_ sender: UIButton) {
    print("food deals selected")
    userSelected(category: enumSelectedDealCategory.enumFoodDeals)

  }
  
  @IBAction func drinkDealsTapped(_ sender: UIButton) {
    print("drinks deals selected")
    userSelected(category: enumSelectedDealCategory.enumDrinkDeals)

  }
  
  @IBAction func dateDealsTapped(_ sender: UIButton) {
    print("date deals selected")
    userSelected(category: enumSelectedDealCategory.enumDateDeals)

  }
//
//  @IBAction func allDealsTapped(_ sender: UIButton) {
//  }
//
//  @IBAction func myDealsTapped(_ sender: UIButton) {
//  }
  
  @IBAction func clearMyDealsTapped(_ sender: UIButton) {
    print("clear my deals selected")
    
    //      warn user about clearing their favs
    let clearAlert = UIAlertController.init(title: "Confirm Clear", message: "Clear your favorite deals? Your favorite deals will be erased from this device.", preferredStyle: .alert)
    
    clearAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"),
                                       style: .default,
                                       handler: { _ in print("clicked ok")
                                        
                                        //      delete all favs from realm
                                        let realm = try! Realm()
                                        try! realm.write {
                                          realm.deleteAll()
                                        }
    }))
    
    clearAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",
                                                                comment: "Cancel"),
                                       style: .default,
                                       handler: { _ in print("clicked cancel")
    }))
    
    self.present(clearAlert, animated: true, completion: nil)
  
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
    if segue.identifier == "unwindSegueFromMenuToDealVC" {
      
      let dealVC = segue.destination as! DealViewController
      dealVC.selectedDealCategory = userSelectedCategory
      
    }
    
  }

}
