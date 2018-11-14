//
//  CheckTableViewCell.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 10/30/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var sharedByView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
