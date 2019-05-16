//
//  StudentLocations.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 13/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import Foundation
struct StudentLocations:Codable {
    let createdAt:String
    let firstName:String
    let lastName :String
    let latitude:Double
    let namelongitude:Double
    let mapString:String
    let mediaURL:String
    let objectId:String
    let uniqueKey:String
    let updatedAt:String
}
