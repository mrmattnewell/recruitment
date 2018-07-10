//
//  CreateReflectionResponse.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 08/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


struct CreateReflectionResponse: Codable {
    
    let reflection: ReflectionResponse
    
    struct ReflectionResponse: Codable {
        let name: String
        let id: Int
    }
}
