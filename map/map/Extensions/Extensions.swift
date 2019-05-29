//
//  Extensions.swift
//  map
//
//  Created by Sarah Alasadi on 15/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
    static let reloadStarted = Notification.Name("reloadStarted")
    static let reloadCompleted = Notification.Name("reloadCompleted")
}
