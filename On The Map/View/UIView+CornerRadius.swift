//
//  UIView+CornerRadius.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(radius: Int) { // Set Rounded Corners on a UIView
        self.layer.cornerRadius = CGFloat(radius)
    }
}
