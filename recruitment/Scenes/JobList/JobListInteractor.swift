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
        if sessionManager.isAuthenticated(){
            let request = JobsRequest()
            irisApi.getJobs(jobRequest: request, user: sessionManager.user) { (jobsResponse) in
                onOk(jobsResponse.map { $0.job() })
            }
        }else{
            irisApi.login(login: LoginRequest(username: (sessionManager.user?.username!)!, password: (sessionManager.user?.password)!), callbackOk: { (loginResponse) in
                self.sessionManager.user = loginResponse.user()
                
                let request = JobsRequest()
                self.irisApi.getJobs(jobRequest: request, user: self.sessionManager.user) { (jobsResponse) in
                    onOk(jobsResponse.map { $0.job() })
                }
            }) {
                
            }
        }
    }
    func logout() {
        try? sessionManager.removeCredentials()
    }
}


protocol JobListInteractor {
    func getJobs(onOk: @escaping (_ jobs: [Job] ) -> Void)
    func logout()
}
