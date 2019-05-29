//
//  UserSession.swift
//  map
//
//  Created by Sarah Alasadi on 15/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation

struct UserSession: Codable {
    let account: Account?
    let session: Session?
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
