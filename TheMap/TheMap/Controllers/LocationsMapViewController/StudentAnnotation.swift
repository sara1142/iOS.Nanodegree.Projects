//
//  StudentAnnotation.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation {
    
    
    var studentInformation: StudentInformation
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, studentInformation: StudentInformation) {
        self.coordinate = coordinate
        self.studentInformation = studentInformation
        
        super.init()
        
        self.title = title
        self.subtitle = subtitle
    }
}
