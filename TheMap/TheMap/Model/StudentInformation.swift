//
//  StudentInformation.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation

struct StudentInformation: Hashable {
    
    
    let firstName: String
    
    let lastName: String
    
    let latitude: Double
    
    let longitude: Double
    
    let mapTextReference: String
    
    let mediaUrl: URL
    
    let key: String
    
    var objectID: String?
    
    var updatedAt: Date?
    
    
    init(firstName: String,
         lastName: String,
         latitude: Double,
         longitude: Double,
         mapTextReference: String,
         mediaUrl: URL,
         key: String
        ) {
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapTextReference = mapTextReference
        self.mediaUrl = mediaUrl
        self.key = key
    }
    
    init?(informationData: [String: AnyObject]) {
        guard let firstName = informationData[ParseAPIClient.JSONResponseKeys.FirstName] as? String else {
            return nil
        }
        
        guard let lastName = informationData[ParseAPIClient.JSONResponseKeys.LastName] as? String else {
            return nil
        }
        
        guard let latitude = informationData[ParseAPIClient.JSONResponseKeys.Latitude] as? Double else {
            return nil
        }
        
        guard let longitude = informationData[ParseAPIClient.JSONResponseKeys.Longitude] as? Double else {
            return nil
        }
        
        guard let mapTextReference = informationData[ParseAPIClient.JSONResponseKeys.MapTextReference] as? String  else {
            return nil
        }
        
        guard let mediaUrlText = informationData[ParseAPIClient.JSONResponseKeys.MediaUrl] as? String,
            let mediaUrl = URL(string: mediaUrlText) else {
                return nil
        }
        
        guard let key = informationData[ParseAPIClient.JSONResponseKeys.InformationKey] as? String else {
            return nil
        }
        
        guard let objectID = informationData[ParseAPIClient.JSONResponseKeys.ObjectID] as? String else {
            return nil
        }
        
        guard let updatedAtText = informationData[ParseAPIClient.JSONResponseKeys.UpdatedAt] as? String,
            let updatedAt = DateFormatter.APIFormatter.date(from: updatedAtText) else {
                return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapTextReference = mapTextReference
        self.mediaUrl = mediaUrl
        self.key = key
        self.objectID = objectID
        self.updatedAt = updatedAt
    }
}
