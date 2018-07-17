//
//  JobListViewController.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit


class JobListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, JobListView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnSignOut: UIButton!
    var jobs: [Job] = []
    var presenter: JobListPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Job List"
        //self.collectionView.register(JobListCollectionCell.self)
        setupPresenter()
        presenter.viewDidLoad()
        btnSignOut.roundedButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSignOut.roundedButton()
    }
    
    func setupPresenter() {
        self.presenter = JobListPresenter(view: self)
        let interactor = JobListInteractorImpl()
        presenter.interactor = interactor
        
    }
    
    func showJobs(jobs: [Job]) {
        self.jobs = jobs
        self.collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let job = jobs[indexPath.row]
        let cell: JobListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobListCollectionCell", for: indexPath) as! JobListCollectionCell
        cell.job = job
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = self.collectionView.frame.width > self.collectionView.frame.height ? (self.collectionView.frame.width / 2) - 20 : self.collectionView.frame.width
        return CGSize(width: width, height: 80.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let job = self.jobs[indexPath.row]
        self.openJobDetail(job: job)
    }
    
    func openJobDetail(job: Job) {
        let storyboard = UIStoryboard(name: "JobsStoryboard", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "JobDescriptionViewController") as? JobDescriptionViewController {
            vc.job = job
            self.show(vc, sender: self)
        }
    }
    @IBAction func tappedSignOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



protocol JobListView {
    func showJobs(jobs: [Job])
}
