//
//  UdacityAPIClientProtocol.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//


import Foundation

protocol UdacityAPIClientProtocol {
    
    
    var userSession: Session? { get }
    
    var userAccount: Account? { get }
    
    var user: User? { get }
    
   
    func logIn(
        withUsername username: String,
        password: String,
        andCompletionHandler handler: @escaping (Account?, Session?, APIClient.RequestError?) -> Void
    )
    
    
    func logOut(withCompletionHandler handler: @escaping (Bool, APIClient.RequestError?) -> Void)
    
    
    func getUserInfo(
        usingUserIdentifier userID: String,
        andCompletionHandler handler: @escaping (User?, APIClient.RequestError?) -> Void
    )
}
