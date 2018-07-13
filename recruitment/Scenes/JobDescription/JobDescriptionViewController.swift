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
import WebKit


class JobDescriptionViewController: UIViewController, JobDescriptionView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var job: Job!
    var presenter: JobDescriptionPresenter!
    
    @IBOutlet weak var indicatorWebView: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var progressUpload: UIProgressView!
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorWebView.startAnimating()
        setupPresenter()
        presenter.viewDidLoad()
        self.btnUpload.roundedButton()
        progressUpload.transform = progressUpload.transform.scaledBy(x: 1, y: 20)
        
        webView.configuration.preferences.javaScriptEnabled = true
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.customUserAgent =  "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
        
    }
    
    func setupPresenter() {
        self.presenter = JobDescriptionPresenter(view: self, controller: self, job: job)
        let interactor = JobDescriptionInteractorImpl()
        presenter.interactor = interactor
        interactor.output = presenter
    }
    
    @IBAction func tappedUpload(_ sender: Any) {
        presenter.uploadTapped()
    }
    
    
    // MARK: JobDescriptionView
    
    func setJob(job: Job) {
        self.title = job.title
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
    
    func onUploadProgress(progress: Float) {
        self.progressUpload.progress = progress
    }
    
    func uploadProgress(show: Bool) {
        self.progressUpload.isHidden = !show
        self.btnUpload.isHidden = show
        self.webView.isHidden = show
    }
    func onFinished() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUrl(_ url: String) {
        let request =  try? URLRequest(url: URL(string: url)!, method: .get, headers: ["auth-token":SessionManager.shared().user!.authenticationKey!])
        webView.load(request!)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.lblTitle.text = "Uploading video to \(job.title)"
        if let url = info[UIImagePickerControllerMediaURL] as? URL {
            presenter.gotVideo(url: url)
        }
        
        dismiss(animated: true, completion: nil)
    }
    deinit {
        webView.scrollView.delegate = nil
    }
    
}

extension JobDescriptionViewController: UIScrollViewDelegate, WKNavigationDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorWebView.stopAnimating()
        indicatorWebView.isHidden = true
    }
}



protocol JobDescriptionView {
    func setJob(job: Job)
    func openPicker()
    func onUploadProgress(progress: Float)
    func uploadProgress(show: Bool)
    func onFinished()
    func setUrl(_ url: String)
    
}
