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


class JobDescriptionViewController: UIViewController, JobDescriptionView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RecorderDelegate {
    
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
        
        progressUpload.transform = progressUpload.transform.scaledBy(x: 1, y: 20)
        
        webView.configuration.preferences.javaScriptEnabled = true
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaPlaybackRequiresUserAction = false
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnUpload.rounded()
    }
    
    // MARK: JobDescriptionView
    
    func setJob(job: Job) {
        self.title = job.title
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
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        /*let imag = UIImagePickerController()
        imag.delegate = self
        imag.sourceType = UIImagePickerControllerSourceType.camera;
        imag.cameraDevice = UIImagePickerControllerCameraDevice.front
        imag.mediaTypes = [kUTTypeMovie as String];
        self.present(imag, animated: true, completion: nil)*/
        let recorderController = RecorderViewController()
        recorderController.recorderDelegate = self
        self.present(recorderController, animated: true, completion: nil)
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
    
    func recorderFinished(recorder: RecorderViewController, url: URL) {
        self.lblTitle.text = "Uploading video to \(job.title)"
        presenter.gotVideo(url: url)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.sourceFrame != nil, let source = navigationAction.sourceFrame.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        if source != navigationAction.request.url?.absoluteString {
            //let someText:String = "Share file"
            let objectsToShare:URL = navigationAction.request.url!
            do{
                let data = try Data(contentsOf: objectsToShare)
                let sharedObjects:[AnyObject] = [data as AnyObject]
                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
                
                self.present(activityViewController, animated: true, completion: nil)
            }catch {}
            
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
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
