//
//  CheckTableViewCell.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 10/30/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {


//    @IBOutlet weak var dishName: UILabel!
//    @IBOutlet weak var sharedByView: UIView!
    var dishName : String?

    
    var dishLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    var sharedByView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(dishLabel)
        self.addSubview(sharedByView)
        
        dishLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        dishLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        dishLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        dishLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        sharedByView.leftAnchor.constraint(equalTo: self.dishLabel.rightAnchor).isActive = true
        sharedByView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sharedByView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sharedByView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let message = dishName {
            dishLabel.text = message
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been impolemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    
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
