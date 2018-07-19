//
//  JobListPresenter.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit


class JobListPresenter {
    
    let view: JobListView
    var interactor: JobListInteractorImpl!
    
    init(view: JobListView) {
        self.view = view
    }
    
    func viewDidLoad(){
        
    }
    
    func logOut(){
        interactor.logout()
    }
    
    func loadJobs(){
        interactor.getJobs { (jobs) in
            self.view.showJobs(jobs: jobs)
        }
    }
}
