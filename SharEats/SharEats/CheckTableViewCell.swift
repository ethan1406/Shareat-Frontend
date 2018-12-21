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
    var price : Int?
    
    var dishLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var priceLabel : UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
        self.addSubview(priceLabel)
        
        dishLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        dishLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        dishLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        dishLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        dishLabel.font = dishLabel.font.withSize(14)
        
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        priceLabel.font = priceLabel.font.withSize(14)
        
        
        sharedByView.leftAnchor.constraint(equalTo: self.dishLabel.rightAnchor).isActive = true
        sharedByView.rightAnchor.constraint(equalTo: self.priceLabel.leftAnchor).isActive = true
        sharedByView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sharedByView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let message = dishName {
            dishLabel.text = message
        }
        
        if let cost = price {
            let priceDecimal: Double = Double(cost)/100
            let priceDisplay = "$" + String(priceDecimal)
            priceLabel.text = priceDisplay
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
