//
//  RoundedButton.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    
    override var isEnabled: Bool {
        didSet {
            UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
                self.alpha = self.isEnabled ? 1 : 0.5
                }.startAnimation()
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
}
