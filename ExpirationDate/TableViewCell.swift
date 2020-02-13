//
//  TableViewCell.swift
//  ExpirationDate
//
//  Created by 宮地篤士 on 2019/06/14.
//  Copyright © 2019 Atsushi Miyaji. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var foodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
