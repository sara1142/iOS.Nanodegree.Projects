//
//  Session.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation


struct Session {
    
   
    let identifier: String
    
    let expiration: Date
    
    
    init?(data: [String: AnyObject]) {
        guard let identifier = data[UdacityAPIClient.JSONResponseKeys.SessionID] as? String else {
            return nil
        }
        
        guard let expirationString = data[UdacityAPIClient.JSONResponseKeys.SessionExpiration] as? String,
            let expiration = DateFormatter.APIFormatter.date(from: expirationString) else {
                return nil
        }
        
        self.identifier = identifier
        self.expiration = expiration
    }
}
