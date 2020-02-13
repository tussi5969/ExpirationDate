//
//  ViewController.swift
//  ExpirationDate
//
//  Created by 宮地篤士 on 2019/06/12.
//  Copyright © 2019 Atsushi Miyaji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func ListButtonTapped() {
        
        
        let saveData = UserDefaults.standard
        
        
        if let foodArray = saveData.array(forKey: "FOOD"){
            if foodArray.count > 0 {
                self.performSegue(withIdentifier: "ToListpage", sender: nil)
            }
        }
        
        let alert: UIAlertController = UIAlertController(
            title: "登録している食材がありません",
            message: "食材を登録してください",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        
        self.present(alert, animated: true, completion: nil)
    }


}

