//
//  FavsTableViewCell.swift
//  FinalProject
//
//  Created by KevinT on 2018-04-10.
//  Copyright © 2018 KevinT. All rights reserved.
//

import UIKit

class FavsTableViewCell: UITableViewCell {
  @IBOutlet weak var dealLabel: UILabel!
  @IBOutlet weak var dealImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
