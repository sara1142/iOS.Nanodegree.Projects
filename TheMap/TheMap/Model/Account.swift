//
//  Account.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation


struct Account {
    
    
    let registered: Bool
    
    let key: String
    
    
    init?(data: [String: AnyObject]) {
        guard let registered = data[UdacityAPIClient.JSONResponseKeys.AccountRegistered] as? Bool else {
            return nil
        }
        
        guard let key = data[UdacityAPIClient.JSONResponseKeys.AccountKey] as? String else {
            return nil
        }
        
        self.registered = registered
        self.key = key
    }
}
