//
//  CheckTableViewCell.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 10/30/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    var dishText : String?
    
    var dishName = UILabel()
    var sharedByView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dishName = UILabel()
        sharedByView = UIView()
        
        dishName.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dishName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dishName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dishName.widthAnchor.constraint(equalToConstant: 150)
        
        contentView.addSubview(dishName)
        
        sharedByView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        sharedByView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        sharedByView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        sharedByView.leadingAnchor.constraint(equalTo: dishName.trailingAnchor).isActive = true
        
        contentView.addSubview(sharedByView)
        //productImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let text = dishText {
            dishName.text = text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
