//
//  TestViewController.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 13/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class RecorderViewController: UIViewController {
    
    var session: AVCaptureSession?
    var userreponsevideoData = NSData()
    var userreponsethumbimageData = NSData()
    var prevLayer: AVCaptureVideoPreviewLayer?
    
    var recordingStatus: RecordingStatus = .unknown
    
    var cameraPosition: AVCaptureDevice.Position = .front
    
    weak var recorderDelegate: RecorderDelegate?
    
    var movieFileOutput: AVCaptureMovieFileOutput
    
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var btnRecording: UIButton!
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    init() {
        self.movieFileOutput = AVCaptureMovieFileOutput()
        super.init(nibName: "RecorderViewController", bundle: Bundle(identifier: "RecorderViewController"))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.movieFileOutput = AVCaptureMovieFileOutput()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.movieFileOutput = AVCaptureMovieFileOutput()
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OrientationUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
        OrientationUtility.lockOrientation(.all)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prevLayer?.frame.size = self.viewPreview.frame.size
        self.btnRecording.circleButton()
    }
    
    func createSession() {
        var input: AVCaptureDeviceInput?
        session = AVCaptureSession()
        let error: NSError? = nil
        do { input = try AVCaptureDeviceInput(device: self.cameraWithPosition(position: self.cameraPosition)!) } catch {return}
        if error == nil {
            session?.addInput(input!)
        } else {
            print("camera input error: \(String(describing: error))")
        }
        prevLayer = AVCaptureVideoPreviewLayer(session: session!)
        prevLayer?.frame.size = self.viewPreview.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        prevLayer?.connection?.videoOrientation = .landscapeRight
        self.viewPreview.layer.addSublayer(prevLayer!)
        
        
        
        let maxDuration: CMTime = CMTimeMake(600, 10)
        movieFileOutput.maxRecordedDuration = maxDuration
        movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
        if self.session!.canAddOutput(movieFileOutput) {
            self.session!.addOutput(movieFileOutput)
        }
        let connection = movieFileOutput.connection(with: .video)
        connection?.videoOrientation = .landscapeRight
        
        movieFileOutput.setRecordsVideoOrientationAndMirroringChangesAsMetadataTrack(true, for: connection!)
        
        session?.startRunning()
        
        self.recordingStatus = .ready
        
    }
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
            
        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    
    func switchTo(position: AVCaptureDevice.Position) {
        session?.beginConfiguration()
        
        //Remove existing input
        guard let currentCameraInput: AVCaptureInput = session?.inputs.first else {
            return
        }
        
        session?.removeInput(currentCameraInput)
        
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = cameraWithPosition(position: .front)
            } else {
                newCamera = cameraWithPosition(position: .back)
            }
        }
        
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        
        if newVideoInput == nil || err != nil {
            print("Error creating capture device input: \(String(describing: err?.localizedDescription))")
        } else {
            session?.addInput(newVideoInput)
        }
        session?.commitConfiguration()
    }
    
    @IBAction func tappedStartRecording(_ sender: Any) {
        switch recordingStatus {
        case .ready:
            self.btnSwitchCamera.isHidden = true
            self.btnBack.isHidden = true
            self.recordingStatus = .starting
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let  filemainurl = URL(string: ("\(documentsURL.appendingPathComponent("temp"))" + ".mov"))
            movieFileOutput.startRecording(to: filemainurl!, recordingDelegate: self)
            self.btnRecording.backgroundColor = UIColor.red
        case .recording:
            movieFileOutput.stopRecording()
        default:
            break
        }
    }
    @IBAction func tappedSwitch(_ sender: Any) {
        if cameraPosition == .front {
            self.cameraPosition = .back
            self.switchTo(position: .back)
            self.btnSwitchCamera.setImage(UIImage(named: "baseline_camera_front_white_36pt"), for: .normal)
        }else{
            self.switchTo(position: .front)
            self.btnSwitchCamera.setImage(UIImage(named: "baseline_camera_rear_white_36pt"), for: .normal)
            self.cameraPosition = .front
            
        }
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension RecorderViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        recordingStatus = .recording
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        recorderDelegate?.recorderFinished(recorder: self, url: outputFileURL)
    }
}

enum RecordingStatus {
    case recording
    case starting
    case ready
    case stopped
    case unknown
}


protocol RecorderDelegate: class {
    func recorderFinished(recorder: RecorderViewController, url: URL)
}
