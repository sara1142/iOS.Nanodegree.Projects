//
//  UnderlinedTextField.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UnderlinedTextField: UITextField {
    
    
    private lazy var underlineLayer: CALayer = {
        let underlineLayer = CALayer()
        underlineLayer.backgroundColor = textColor?.cgColor ?? UIColor.black.cgColor
        
        return underlineLayer
    }()
    
    @IBInspectable var underlineHeight: CGFloat = 1
    
    
    override func prepareForInterfaceBuilder() {
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if underlineLayer.superlayer == nil {
            underlineLayer.frame = CGRect(x: 0, y: frame.height + 1, width: frame.width, height: underlineHeight)
            layer.addSublayer(underlineLayer)
        }
    }
}
