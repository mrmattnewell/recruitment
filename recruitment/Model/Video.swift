//
//  Video.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 08/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class Video {
    var startDate: Date?
    var endDate: Date?
    var localPath: URL?
    var awsParams: AwsVideoParams?
    var vmk: String?
    
    
    struct AwsVideoParams {
        var amazonAccessKey: String
        var amazonSecretKey: String
        var amazonTokenTemporary: String
        var amazonBucket: String
        var endpoint: String
        var amazonObjectNamePrefix: String
        var uploadKey: String
    }
}



extension Video {
    func paramsFrom(authorizationResponse: AuthorizationResponse) {
        self.vmk = authorizationResponse.upload.vmk
        let uploadKey = "\(authorizationResponse.upload.parameters.objectName)/1234567890_part_1.mov"
        self.awsParams = AwsVideoParams(amazonAccessKey: authorizationResponse.upload.parameters.accessKey,
                                        amazonSecretKey: authorizationResponse.upload.parameters.secretKey,
                                        amazonTokenTemporary: authorizationResponse.upload.parameters.temporaryToken,
                                        amazonBucket: authorizationResponse.upload.parameters.bucket,
                                        endpoint: authorizationResponse.upload.parameters.endpoint,
                                        amazonObjectNamePrefix: authorizationResponse.upload.parameters.objectName,
                                        uploadKey: uploadKey)
    }
}
