//
//  AuthorizationResponse.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 09/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation

struct AuthorizationResponse: Codable {
    
    let upload: UploadResponse
    
    
    struct UploadResponse: Codable {
        let parameters: ParametersResponse
        
        struct ParametersResponse: Codable {
            let objectName: String
            let bucket: String
            let accessKey: String
            let secretKey: String
            let endpoint: String
            let temporaryToken: String
            
            private enum CodingKeys: String, CodingKey {
                case objectName = "object_name_prefix"
                case accessKey = "access_key"
                case secretKey = "secret_access_key"
                case bucket = "bucket"
                case endpoint = "endpoint"
                case temporaryToken = "x-amz-security-token"
            }
            
        }
        
    }
}
