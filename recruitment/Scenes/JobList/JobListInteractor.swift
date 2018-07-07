//
//  JobListInteractor.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class JobListInteractorImpl: JobListInteractor {
    
    let irisApi = IrisApi()
    let sessionManager = SessionManager.shared()
    
    
    func getJobs(onOk: @escaping ([Job]) -> Void) {
        guard let user = sessionManager.user else { return }
        let request = JobsRequest()
        irisApi.getJobs(jobRequest: request, user: user) { (jobsResponse) in
            onOk(jobsResponse.map { $0.job() })
        }
    }
}


protocol JobListInteractor {
    func getJobs(onOk: @escaping (_ jobs: [Job] ) -> Void)
}
