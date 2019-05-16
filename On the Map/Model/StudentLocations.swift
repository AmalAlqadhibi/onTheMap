//
//  StudentLocations.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 13/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import Foundation
struct StudentsLocations:Codable {
    let createdAt:String?
    let firstName:String?
    let lastName :String?
    let latitude:Double?
    let longitude:Double?
    let mapString:String?
    let mediaURL:String?
    let objectId:String?
    let uniqueKey:String?
    let updatedAt:String?
}
class Global {
    static var studentsLocations = [StudentsLocations]()
    static var uniqueKey : String!
}
