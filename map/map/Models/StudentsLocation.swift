//
//  StudentsLocation.swift
//  map
//
//  Created by Sarah Alasadi on 15/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//


import Foundation

struct StudentsLocation {
    
    static var shared = StudentsLocation()
    
    private init() {}
    
    var studentsInformation = [StudentInformation]()
    
}
