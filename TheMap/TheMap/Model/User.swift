//
//  User.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation

struct User {
    
    
    let firstName: String
    
    let lastName: String
    
    let key: String
    
    
    init?(userData: [String: AnyObject]) {
        guard let firstName = userData[UdacityAPIClient.JSONResponseKeys.UserFirstName] as? String,
            let lastName = userData[UdacityAPIClient.JSONResponseKeys.UserLastName] as? String else {
                return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        
        guard let key = userData[UdacityAPIClient.JSONResponseKeys.UserKey] as? String else {
            return nil
        }
        
        self.key = key
    }
}
