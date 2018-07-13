//
//  JobDescriptionInteractor.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 07/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import AWSS3
import Foundation

class JobDescriptionInteractorImpl: JobDescriptionInteractor {
    let irisApi = IrisApi()
    let sessionManager = SessionManager.shared()
    weak var job: Job?
    var output: JobDescriptionInteractorOut?
    
    func createReflection(videoURL: URL, job: Job) {
        guard let startDate = job.video?.startDate else { return }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy/MM/dd"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        let uuid = UUID().uuidString
        let request = CreateReflectionRequest(title: job.title, uuid: uuid, startDate: dateFormatterGet.string(from: startDate), endTime: "18:50")
        job.video?.localPath = videoURL
        
        irisApi.createReflection(creationRequest: request, user: sessionManager.user) { reflectionResponse in
            let shareRequest = ShareReflectionGroupRequest(reflectionId: reflectionResponse.reflection.id, groupId: self.job!.id)
            self.irisApi.shareReflectionToGroup(shareRequest: shareRequest, user: self.sessionManager.user, callbackOk: nil)
            self.authorize(reflectionResponse: reflectionResponse)
        }
    }
    
    func authorize(reflectionResponse: CreateReflectionResponse) {
        let request = AuthorizationRequest(id: reflectionResponse.reflection.id)
        irisApi.authorize(jobRequest: request, user: sessionManager.user) { [weak self] authorizationResponse in
            self?.job?.video?.paramsFrom(authorizationResponse: authorizationResponse)
            self?.startUploading(job: self?.job)
        }
    }
    
    func completeUpload() {
        guard let vmk = self.job?.video?.vmk else { return }
        let confirmationReq = ConfirmationRequest(vmk: vmk)
        irisApi.confirmation(confirmationRequest: confirmationReq, user: sessionManager.user) {[weak self] (response) in
            self?.output?.onUploadConfirmed()
        }
    }
    
    func getJobDescription(job: Job, callback: @escaping (_ url: String) -> Void){
        let pagesRequest = PagesRequest(groupId: job.id)
        irisApi.pages(pagesRequest: pagesRequest, user: sessionManager.user) { pageResponse in
            guard let pageId = pageResponse?.id else { return }
            callback(Endpoints.render(page: pageId))
            /*let renderRequest = RenderJobRequest(id: pageId)
            self.irisApi.renderJobPage(renderRequest: renderRequest, user: self.sessionManager.user) { renderResponse in
                callback(renderResponse.body.html)
            }*/
        }
    }
    
    
    func addVideo(job: Job) {
        self.job = job
        let video = Video()
        video.startDate = Date()
        job.video = video
    }
    
    
    // MARK: AWS
    
    func startUploading(job: Job?){
        guard let awsParams = job?.video?.awsParams, let path = job?.video?.localPath  else  { return }
        
        let transferUtility = AWSTransfer(video: self.job?.video)
        let fileURL = path
        
        let expression = AWSS3TransferUtilityMultiPartUploadExpression()
        expression.progressBlock = { _, progress in
            NSLog("AWSS3TransferUtilityMultiPartUploadExpression progress")
            self.output?.onProgressUpload(progress: Float((progress.completedUnitCount * 100) / progress.totalUnitCount))
        }
        
        let completionBlockUpload: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock? = {
            [weak self] _, error in
            if let e = error as NSError? {
                print("Error: \(e.localizedDescription)")
                return
            }
            self?.completeUpload()
        }
        
        let task = transferUtility?.uploadUsingMultiPart(fileURL: fileURL,
                                                         bucket: awsParams.amazonBucket,
                                                         key: awsParams.uploadKey,
                                                         contentType: "video/mov",
                                                         expression: expression, completionHandler: completionBlockUpload)
        
        task?.continueWith(executor: AWSExecutor.mainThread()) { (task) -> AnyObject? in
            
            if let error = task.error as NSError? {
                print("Error: \(error.localizedDescription)")
                //self?.errorVideo(error, video: video)
            }
            NSLog("continueWith!!")
            
            if let res = task.result {
                // Do something with uploadTask.
                //self?.transferTasks[video.uploadKey] = res
            }
            return nil
        }
    }
    
    
    private func AWSTransfer(video: Video?) -> AWSS3TransferUtility? {
        guard let key = video?.awsParams?.uploadKey else { return nil }
        
        AWSS3TransferUtility.register(with: self.configurationAWSfor(params: video?.awsParams)!, forKey: key)
        let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: key)
        return transferUtility
    }
    
    private func configurationAWSfor(params: Video.AwsVideoParams?) -> AWSServiceConfiguration? {
        guard let accessKey = params?.amazonAccessKey,
            let secretKey = params?.amazonSecretKey,
            let sessionToken = params?.amazonTokenTemporary,
            let endpoint = params?.endpoint
            else {
                return nil
        }
        let credentialsProvider = AWSBasicSessionCredentialsProvider(accessKey: accessKey, secretKey: secretKey, sessionToken: sessionToken)
        
        let configuration = AWSServiceConfiguration(region: AWSRegionType.regionTypeForString(regionString: endpoint), endpoint: AWSEndpoint(urlString: "https://\(endpoint)"), credentialsProvider: credentialsProvider)
        return configuration
    }
    
}

protocol JobDescriptionInteractor {
    func createReflection(videoURL: URL, job: Job)
    func addVideo(job: Job)
    func getJobDescription(job: Job, callback: @escaping (_ url: String) -> Void)
}

protocol JobDescriptionInteractorOut {
    func onProgressUpload(progress: Float)
    func onUploadConfirmed()
}
