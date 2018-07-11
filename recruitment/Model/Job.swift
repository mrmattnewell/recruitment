//
//  Job.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class Job {
    let title: String
    let id: Int
    let description: String
    var video: Video?
    
    init(id: Int, title: String, description: String) {
        self.title = title
        self.id = id
        self.description = description
    }
}
