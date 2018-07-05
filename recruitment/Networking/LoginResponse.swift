//
//  LoginResponse.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


struct LoginResponse: Codable {
    
    let login: Login

    struct Login: Codable {
        let authorization: Authorization
    }
    
    struct Authorization: Codable {
        let username: String
        let key: String
        let userId: Int
        
        private enum CodingKeys: String, CodingKey {
            case key
            case username
            case userId = "user_id"
        }
        
    }
    
}






