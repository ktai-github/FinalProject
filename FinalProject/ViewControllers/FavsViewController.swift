//
//  FavsViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-10.
//  Copyright © 2018 KevinT. All rights reserved.
//
// BUG: L'abboir brunch deal will crash the app if delete from My Deals

// Next Deal button should be more obvious to the user to that this is a button and that you have to click it to see next deal

import UIKit

class FavsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var favsTableView: UITableView!

  var tempDealPlace = DealPlace()
  var deals = RealmManager.realmQueryAllRecords()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.favsTableView.dataSource = self
    self.favsTableView.delegate = self
    self.favsTableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deals.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FavsTableViewCell else {
      print("guard let cell error")
      let cell = FavsTableViewCell(style: .default, reuseIdentifier: "Cell")
      return cell
    }
    
    cell.dealLabel.text = deals[indexPath.row].dealName
    let photoManager = PhotoManager()
    photoManager.photoNetworkRequest(url:  deals[indexPath.row].dealImageUrl) { [unowned self] (image: UIImage) in
      DispatchQueue.main.async {
        cell.dealImageView.image = image
      }
    }

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.view.bounds.height / 3 //return row height that is depending on the device screen size
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    let dealPlace = DealPlace()
    let cell = tableView.cellForRow(at: indexPath) as? FavsTableViewCell
    guard let unwDealName = cell?.dealLabel.text else {
      print("no deal label")
      return
    }
    
//    get deal name from table row selected by user
    dealPlace.dealName = unwDealName
    dealPlace.dealFaved = false
    
//    delete in realm and delete in table view
    RealmManager.realmDelete(unwDealName, dealPlace)

    tableView.beginUpdates()
    tableView.deleteRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()
    print("deleted row")
    
//    BUG: user view a deal in deal vc that is already a fav
//    and then immediate go to fav list and view the same deal
//    go to the favvc and delete that deal
//    attempting back out to the dealvc might crash the app
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//    segue with selected deal
    tempDealPlace = deals[indexPath.row]
    print(tempDealPlace.dealName + " at " + tempDealPlace.placeName + " on " + tempDealPlace.dealDaysAvailable + " stored temporarily")
    performSegue(withIdentifier: "unwindSegueToDealVC", sender: self)

  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      if segue.identifier == "unwindSegueToDealVC" {
        
        let dealVC = segue.destination as! DealViewController
        dealVC.selectedDealCategory = enumSelectedDealCategory.enumMyDeals
        dealVC.tempDealPlace = tempDealPlace
        
      } else if segue.identifier == "segueFromMyDealsToMapView" {
        
        let mapVC = segue.destination as! MapViewController
        mapVC.selectedDealCategory = enumSelectedDealCategory.enumMyDeals
      }
    }
  
}
