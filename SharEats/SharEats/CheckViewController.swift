//
//  Check.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 10/27/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit


class CheckViewController: UIViewController {
    
    var orders: [Order]?
    var buttonBar: UIView!
    
    @IBOutlet weak var groupOrIndividual: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBar = UIView()
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.orange
        view.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: groupOrIndividual.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: groupOrIndividual.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: groupOrIndividual.widthAnchor, multiplier: 1 / CGFloat(groupOrIndividual.numberOfSegments)).isActive = true
        
        groupOrIndividual.backgroundColor = .clear
        groupOrIndividual.tintColor = .clear
        
        groupOrIndividual.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        groupOrIndividual.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedStringKey.foregroundColor: UIColor.orange
            ], for: .selected)
        
        groupOrIndividual.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        
        for order in orders!{
            print(order.name)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.groupOrIndividual.frame.width / CGFloat(self.groupOrIndividual.numberOfSegments)) * CGFloat(self.groupOrIndividual.selectedSegmentIndex)
        }
    }

}

