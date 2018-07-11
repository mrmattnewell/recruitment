//
//  JobsRequest.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


struct JobsRequest: Codable {
    let search: String = "JOBGROUP,"
    let perPage: Int = -1
    
    private enum CodingKeys: String, CodingKey {
        case search
        case perPage = "per_page" 
    }
}
