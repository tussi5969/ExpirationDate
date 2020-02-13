//
//  ListTableViewController.swift
//  ExpirationDate
//
//  Created by 宮地篤士 on 2019/06/13.
//  Copyright © 2019 Atsushi Miyaji. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var foodArray: [Dictionary<String, String>] = []
    
    let saveDate = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
            forCellReuseIdentifier: "cell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        print(saveDate.array(forKey: "FOOD"))
        super.viewWillAppear(true)
        if saveDate.array(forKey: "FOOD") != nil {
            foodArray = saveDate.array(forKey: "FOOD") as! [Dictionary<String, String>]
        }
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! TableViewCell
        
        
        let nowIndexPathDictionary = foodArray[indexPath.row]
        
        print(nowIndexPathDictionary)
        
        cell.dateLabel.text = nowIndexPathDictionary["date"]
        cell.foodLabel.text = nowIndexPathDictionary["food"]
        
        print(cell.dateLabel.text)
        print(cell.foodLabel.text)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "消費") { (action, index) -> Void in
//            self.saveDate.array(forKey: "FOOD").remove(at: indexPath.row)
            let alert = UIAlertController(
                title: "消費しました！！",
                message: "食材名：\(self.foodArray[indexPath.row]["food"] ?? "テスト")",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
            
            self.foodArray.remove(at: indexPath.row)
            self.saveDate.set(self.foodArray, forKey: "FOOD")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
