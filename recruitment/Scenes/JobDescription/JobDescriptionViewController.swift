//
//  JobDescriptionViewController.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 07/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices


class JobDescriptionViewController: UIViewController, JobDescriptionView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    var job: Job!
    var presenter: JobDescriptionPresenter!
    
    @IBOutlet weak var btnUpload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        presenter.viewDidLoad()
    }
    
    func setupPresenter() {
        self.presenter = JobDescriptionPresenter(view: self, controller: self, job: job)
        let interactor = JobDescriptionInteractorImpl()
        presenter.interactor = interactor
    }
    
    @IBAction func tappedUpload(_ sender: Any) {
        presenter.uploadTapped()
    }
    
    
    // MARK: JobDescriptionView
    
    func setJob(job: Job) {
        self.lblTitle.text = job.title
    }
    
    func openPicker() {
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = btnUpload
            alert.popoverPresentationController?.sourceRect = btnUpload.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        let imag = UIImagePickerController()
        imag.delegate = self
        imag.sourceType = UIImagePickerControllerSourceType.camera;
        imag.cameraDevice = UIImagePickerControllerCameraDevice.front
        imag.mediaTypes = [kUTTypeMovie as String];
        self.present(imag, animated: true, completion: nil)
    }
    
    func openGallery() {
        let imag = UIImagePickerController()
        imag.delegate = self
        imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imag.mediaTypes = [kUTTypeMovie as String];
        self.present(imag, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerMediaURL] as? URL {
            presenter.gotVideo(url: url)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}



protocol JobDescriptionView {
    func setJob(job: Job)
    func openPicker()
}
