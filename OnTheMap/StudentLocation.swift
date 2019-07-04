//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Haya Mousa on 14/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import Foundation


struct StudentLocation : Codable {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
 
}


extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}
