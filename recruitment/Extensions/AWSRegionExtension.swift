//
//  AWSRegionExtension.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 10/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import AWSS3


extension AWSRegionType {
    
    /**
     Return an AWSRegionType for the given string
     
     - Parameter regionString: The Region name (e.g. us-east-1) as a string
     
     - Returns: A new AWSRegionType for the given string, Unknown if no region was found.
     */
    static func regionTypeForString(regionString: String) -> AWSRegionType {
        switch regionString {
        case "s3-us-east-1.amazonaws.com": return .USEast1
        case "s3-us-west-1.amazonaws.com": return .USWest1
        case "s3-us-west-2.amazonaws.com": return .USWest2
        case "s3-eu-west-1.amazonaws.com": return .EUWest1
        case "s3-eu-central-1.amazonaws.com": return .EUCentral1
        case "s3-ap-northeast-1.amazonaws.com": return .APNortheast1
        case "s3-ap-northeast-2.amazonaws.com": return .APNortheast2
        case "s3-ap-southeast-1.amazonaws.com": return .APSoutheast1
        case "s3-ap-southeast-2.amazonaws.com": return .APSoutheast2
        case "s3-sa-east-1.amazonaws.com": return .SAEast1
        case "s3-cn-north-1.amazonaws.com": return .CNNorth1
        case "s3-us-gov-west-1.amazonaws.com": return .USGovWest1
        default: return .Unknown
        }
    }
}
