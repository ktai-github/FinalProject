//
//  MenuTableViewController.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-09.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit

let notificationKey = "selectedMenuItem.NotificationKey"

class MenuTableViewController: UITableViewController {
  
  @IBOutlet weak var randomDealsTableViewCell: UITableViewCell!
  @IBOutlet weak var drinkDealsTableViewCell: UITableViewCell!
  
  var userSelectedCategory: String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
//      NotificationCenter.default.addObserver(self, selector: #selector(setToRandomDeals), name: NSNotification.Name(rawValue: notificationKey), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

//  @objc func setToRandomDeals() {
//    print ("Random Deals")
//  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return self.tableView.numberOfRows(inSection: 0)
//    }

  
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//
//        return cell
//    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      // selected random deals
      print("random deals selected")
      userSelectedCategory = "random deals selected"
      NotificationCenter.default.post(name: Notification.Name.deal,
                                      object: userSelectedCategory)
      self.navigationController?.popViewController(animated: true)
    case 1:
      // selected restaurant deals
      print("food deals selected")
      self.navigationController?.popViewController(animated: true)

    case 2:
      // selected drinks deals
      print("drinks deals selected")
      self.navigationController?.popViewController(animated: true)

    case 3:
      // selected date deals
      print("date deals selected")
      self.navigationController?.popViewController(animated: true)

    case 4:
      // selected fun deals
      print("fun deals selected")
      self.navigationController?.popViewController(animated: true)

    case 5:
      // selected group deals
      print("group deals selected")
      self.navigationController?.popViewController(animated: true)

    case 6:
      // selected my deals
      print("my deals selected")
      
    default:
      // selected clear my deals
      print("clear my deals selected")
      
//      warn user about clearing their favs
      let clearAlert = UIAlertController.init(title: "Confirm Clear", message: "Clear your favorite deals? Your favorite deals will be erased from your device.", preferredStyle: .alert)
      clearAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"), style: .default, handler: { _ in print("alert presented")
      }))
      self.present(clearAlert, animated: true, completion: nil)
    }
  }
  
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
