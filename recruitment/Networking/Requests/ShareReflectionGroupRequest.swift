//
//  ShareReflectionGroupRequest.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 11/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


struct ShareReflectionGroupRequest: Codable {
    
    var reflectionId: Int?
    let groupId: Int
    
    private enum CodingKeys: String, CodingKey {
        case groupId = "sharee_group_id"
    }
    
}
