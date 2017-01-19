//
//  UIView+borderColor.swift
//  ImageCapture
//
//  Created by Prabin K Datta on 18/01/17.
//  Copyright © 2017 Prabin K Datta. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var borderColor : UIColor? {
        set (newValue) {
            self.layer.borderColor = (newValue ?? UIColor.green).cgColor
            self.layer.borderWidth = 5
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
}
