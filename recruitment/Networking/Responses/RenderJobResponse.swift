//
//  RenderJobResponse.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 13/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


struct RenderJobResponse: Codable {
    let id: Int
    let title: String
    let body: RenderJobBody
    
    
    struct RenderJobBody: Codable {
        let html: String
    }
    
}
