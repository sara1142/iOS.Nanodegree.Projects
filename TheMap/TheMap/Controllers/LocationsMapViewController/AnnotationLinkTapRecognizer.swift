//
//  AnnotationLinkTapRecognizer.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

class AnnotationLinkTapRecognizer: UITapGestureRecognizer {
    
    
    var link: String
    
    
    init(target: Any?, action: Selector?, link: String) {
        self.link = link
        
        super.init(target: target, action: action)
    }
    
}
