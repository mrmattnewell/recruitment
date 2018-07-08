//
//  JobDescriptionPresenter.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 07/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class JobDescriptionPresenter {
    
    var interactor: JobDescriptionInteractor!
    let controller: JobDescriptionViewController
    let job: Job
    let view: JobDescriptionView
    
    init(view: JobDescriptionView, controller: JobDescriptionViewController, job: Job) {
        self.controller = controller
        self.job = job
        self.view = view
    }
    
    
    func viewDidLoad(){
        view.setJob(job: job)
    }
    
    func gotVideo(url: URL) {
        self.job.video?.endDate = Date()
        interactor.createReflection(videoURL: url, job: self.job)
    }
    
    func uploadTapped(){
        interactor.addVideo(job: self.job)
        view.openPicker()
    }

}
