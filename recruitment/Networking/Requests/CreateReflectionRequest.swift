//
//  CreateObservationRequest.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 08/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


struct CreateReflectionRequest: Codable {
    let name: String
    let uuid: String
    let startDate: String
    let endTime: String
    
    
    private enum CodingKeys: String, CodingKey {
        case name
        case uuid
        case startDate = "start_date"
        case endTime = "end_time"
    }
}

