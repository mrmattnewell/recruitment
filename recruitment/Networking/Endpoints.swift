//
//  Endpoints.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class Endpoints {
    static let mobileApiKey = "mobileehHFHIhJEVoDOmurlRvxVFlw"
    static let host = "http://atlas-stg.irisconnect.net:3030"
    static let login = "\(host)/v1/mobile/login"
    static let jobs = "\(host)/v1/users/me/groups"
    static let createReflection = "\(host)/v1/mobile/reflections"
    static let authorization = "\(host)/v1/mobile/primary"
    static let confirmation = "\(host)/v1/mobile/completed"
    
    static func shareToGroup(reflectionId: Int) -> String {
        return "\(host)/v1/reflections/\(reflectionId)/shares"
    }
}
