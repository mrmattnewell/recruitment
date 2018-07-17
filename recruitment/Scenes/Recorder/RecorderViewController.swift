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
    
    
    init() {
        super.init(nibName: "RecorderViewController", bundle: Bundle(identifier: "RecorderViewController"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func createSession() {
        
        var input: AVCaptureDeviceInput?
        let  movieFileOutput = AVCaptureMovieFileOutput()
        var prevLayer: AVCaptureVideoPreviewLayer?
        prevLayer?.frame.size = self.view.frame.size
        session = AVCaptureSession()
        let error: NSError? = nil
        do { input = try AVCaptureDeviceInput(device: self.cameraWithPosition(position: .front)!) } catch {return}
        if error == nil {
            session?.addInput(input!)
        } else {
            print("camera input error: \(error)")
        }
        prevLayer = AVCaptureVideoPreviewLayer(session: session!)
        prevLayer?.frame.size = self.view.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        prevLayer?.connection?.videoOrientation = .portrait
        self.view.layer.addSublayer(prevLayer!)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let  filemainurl = URL(string: ("\(documentsURL.appendingPathComponent("temp"))" + ".mov"))
        
        
        let maxDuration: CMTime = CMTimeMake(600, 10)
        movieFileOutput.maxRecordedDuration = maxDuration
        movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
        if self.session!.canAddOutput(movieFileOutput) {
            self.session!.addOutput(movieFileOutput)
        }
        session?.startRunning()
        movieFileOutput.startRecording(to: filemainurl!, recordingDelegate: self)
        
    }
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == position {
                return device as? AVCaptureDevice
            }
        }
        return nil
    }
    @IBAction func pressbackbutton(sender: AnyObject) {
        session?.stopRunning()
        
    }
    
}
extension RecorderViewController: AVCaptureFileOutputRecordingDelegate
{
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print(fileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    /*func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print(fileURL)
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        print(outputFileURL)
        let filemainurl = outputFileURL
        
        do
        {
            let asset = AVURLAsset(URL: filemainurl, options: nil)
            print(asset)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(CGImage: cgImage)
            userreponsethumbimageData = NSData(contentsOfURL: filemainurl)!
            print(userreponsethumbimageData.length)
            print(uiImage)
            // imageData = UIImageJPEGRepresentation(uiImage, 0.1)
        }
        catch let error as NSError
        {
            print(error)
            return
        }
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
        let VideoFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("mergeVideo\(arc4random()%1000)d")!.URLByAppendingPathExtension("mp4")!.absoluteString
        
        if NSFileManager.defaultManager().fileExistsAtPath(VideoFilePath!)
            
        {
            do
                
            {
                try NSFileManager.defaultManager().removeItemAtPath(VideoFilePath!)
            }
            catch { }
            
        }
        let tempfilemainurl =  NSURL(string: VideoFilePath!)!
        let sourceAsset = AVURLAsset(URL: filemainurl!, options: nil)
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = tempfilemainurl
        assetExport.exportAsynchronouslyWithCompletionHandler { () -> Void in
            switch assetExport.status
            {
            case AVAssetExportSessionStatus.Completed:
                dispatch_async(dispatch_get_main_queue(),
                               {
                                do
                                {
                                    SVProgressHUD .dismiss()
                                    self.userreponsevideoData = try NSData(contentsOfURL: tempfilemainurl, options: NSDataReadingOptions())
                                    print("MB - \(self.userreponsevideoData.length) byte")
                                    
                                    
                                }
                                catch
                                {
                                    SVProgressHUD .dismiss()
                                    print(error)
                                }
                })
            case  AVAssetExportSessionStatus.Failed:
                print("failed \(assetExport.error)")
            case AVAssetExportSessionStatus.Cancelled:
                print("cancelled \(assetExport.error)")
            default:
                print("complete")
                SVProgressHUD .dismiss()
            }
            
        }
    }*/
    
}
