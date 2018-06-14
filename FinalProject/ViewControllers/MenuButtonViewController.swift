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
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
//  MARK: - User Selection Functions
  
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

  @IBAction func myDealsTapped(_ sender: UIButton) {
    print("my deals selected")
    //segue in storyboard
  }
  
  @IBAction func clearMyDealsTapped(_ sender: UIButton) {
    print("clear my deals selected")
    
    //      warn user about clearing their favs
    let clearAlert = UIAlertController.init(title: "Confirm Clear", message: "Clear your favorite deals? Your favorite deals will be erased from this device.", preferredStyle: .alert)
    
    clearAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"),
                                       style: .default,
                                       handler: { _ in print("clicked ok")
                                        
                                        //      delete all favs from realm
                                        RealmManager.realmDeleteAll()
    }))
    
    clearAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",
                                                                comment: "Cancel"),
                                       style: .default,
                                       handler: { _ in print("clicked cancel")
    }))
    
    self.present(clearAlert, animated: true, completion: nil)
  
  }
  
  //  navigate to deal vc with the category that was selected for filtering deals
  func userSelected(category: enumSelectedDealCategory) {
    
    userSelectedCategory = category
        
    performSegue(withIdentifier: "unwindSegueFromMenuToDealVC", sender: self)
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
