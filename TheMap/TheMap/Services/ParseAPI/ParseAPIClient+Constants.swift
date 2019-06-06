//
//  ParseAPIClient+Constants.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation


extension ParseAPIClient {
    
    enum API {
        static let Scheme = "https"
        static let Host = "onthemap-api.udacity.com"
        static let Path = "/v1"
    }
    
    enum Methods {
        static let StudentLocation = "StudentLocation"
    }
    
    enum ParameterKeys {
        static let Limit = "limit"
        static let Page = "skip"
        static let WhereQuery = "where"
    }
    
    enum JSONResponseKeys {
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapTextReference = "mapString"
        static let MediaUrl = "mediaURL"
        static let InformationKey = "uniqueKey"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let CreatedAt = "createdAt"
    }
    
    enum UserInfoKeys {
        static let CreatedStudentInformation = "created_information"
    }
}

extension NSNotification.Name {
    static let StudentInformationCreated = NSNotification.Name("student_notification_created")
}
