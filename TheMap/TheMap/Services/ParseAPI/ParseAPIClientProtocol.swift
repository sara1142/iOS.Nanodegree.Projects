//
//  ParseAPIClientProtocol.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//



import Foundation

protocol ParseAPIClientProtocol {
    
   
    var studentLocations: [StudentInformation] { get set }
    
   
    func fetchStudentLocations(
        withLimit limit: Int,
        skippingPages pagesToSkip: Int,
        andUsingCompletionHandler handler: @escaping ([StudentInformation]?, APIClient.RequestError?) -> Void
    )
  
    func fetchStudentLocation(
        byUsingUniqueKey key: String,
        andCompletionHandler handler: @escaping (StudentInformation?, APIClient.RequestError?) -> Void
    )
    
   
    func createStudentLocation(
        _ information: StudentInformation,
        withCompletionHandler handler: @escaping (StudentInformation?, APIClient.RequestError?) -> Void
    )
    
    func updateStudentLocation(
        _ information: StudentInformation,
        withCompletionHandler handler: @escaping (StudentInformation?, APIClient.RequestError?) -> Void
    )
    
    func sortLocations()
}
