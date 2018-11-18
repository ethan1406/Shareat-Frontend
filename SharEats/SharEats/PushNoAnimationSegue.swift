//
//  PushNoAnimationSegue.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 11/17/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        self.source.navigationController?.pushViewController(self.destination, animated: false)
    }
}
