//
//  JobDescriptionInteractor.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 07/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class JobDescriptionInteractorImpl: JobDescriptionInteractor {
    let irisApi = IrisApi()
    let sessionManager = SessionManager.shared()
    
    
    func createReflection(videoURL: URL, job: Job) {
        guard let startDate = job.video?.startDate else { return }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy/MM/dd"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        let request = CreateReflectionRequest(name: job.title, uuid: "", startDate: dateFormatterGet.string(from: startDate), endTime: "")
        irisApi.createReflection(creationRequest: request, user: sessionManager.user) { (reflectionResponse) in
            
        }
    }
    
    func addVideo(job: Job) {
        var video = Video()
        video.startDate = Date()
        job.video = video
    }
    
    
}


protocol JobDescriptionInteractor {
    func createReflection(videoURL: URL, job: Job)
    func addVideo(job: Job)
}
