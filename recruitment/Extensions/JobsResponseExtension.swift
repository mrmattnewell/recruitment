//
//  JobsResponseExtension.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


extension JobsResponse{
    func job() -> Job {
        let job = Job(title: self.name)
        return job
    }
}
