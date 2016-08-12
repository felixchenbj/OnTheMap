//
//  RoundCornerButton.swift
//  OnTheMap
//
//  Created by felix on 8/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class RoundCornerButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 1.0
        layer.borderColor = backgroundColor?.CGColor
        layer.cornerRadius = roundRectCornerRadius
    }
    
    var roundRectCornerRadius: CGFloat = 5.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color of the background rectangle
    var roundRectColor: UIColor = UIColor.blueColor() {
        didSet {
            self.setNeedsLayout()
        }
    }
}
