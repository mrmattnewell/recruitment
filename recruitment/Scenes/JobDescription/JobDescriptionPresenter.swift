//
//  JobDescriptionPresenter.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 07/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class JobDescriptionPresenter: JobDescriptionInteractorOut {
    
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
        view.uploadProgress(show: false)
        interactor.getJobDescription(job: self.job) { (url) in
            self.view.setUrl(url)
        }
    }
    
    func gotVideo(url: URL) {
        view.uploadProgress(show: true)
        self.job.video?.endDate = Date()
        interactor.createReflection(videoURL: url, job: self.job)
    }
    
    func uploadTapped(){
        interactor.addVideo(job: self.job)
        view.openPicker()
    }
    
    // MARK: JobDescriptionInteractorOut
    
    func onProgressUpload(progress: Float) {
        DispatchQueue.main.async {
            self.view.onUploadProgress(progress: progress / 100)
        }
    }
    
    func onUploadConfirmed() {
        DispatchQueue.main.async {
            self.view.onFinished()
        }
    }

}
