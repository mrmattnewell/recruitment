//
//  ParameterEncodingExtension.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 09/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import Alamofire


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self.data(using: .utf8)
        return request
    }
    
}
