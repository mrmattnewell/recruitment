//
//  IrisApi.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


class IrisApi {
    
    func login(login: LoginRequest, callbackOk: @escaping (_ response: LoginResponse) -> Void, onError: @escaping () -> Void) {
        Alamofire.request(Endpoints.login, method: .post, parameters: login.dictionary, encoding: JSONEncoding.default, headers: mobileApiKeyHeader).responseData { (response) in
            guard self.isOk(response: response.response) else {
                onError()
                return
            }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode(LoginResponse.self, from: json)
                    callbackOk(res)
                }catch { onError() }
            }
        }
    }
    
    func getJobs(jobRequest: JobsRequest, user: User?, callbackOk: @escaping (_ response: [JobsResponse]) -> Void) {
        guard let user = user else { return }
        Alamofire.request(Endpoints.jobs, method: .get, parameters: jobRequest.dictionary, encoding: URLEncoding.queryString, headers: self.authenticationHeader(user: user)).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode([JobsResponse].self, from: json)
                    callbackOk(res)
                }catch { }
            }
        }
    }
    
    
    func createReflection(creationRequest: CreateReflectionRequest, user: User?, callbackOk: @escaping (_ response: CreateReflectionResponse) -> Void) {
        guard let user = user else { return }
        let params = creationRequest.dictionary!.compactMap( { (key, value) -> String? in
            "\(key)=\(value)"
        }).joined(separator: "&")
        Alamofire.request(Endpoints.createReflection, method: .post, parameters: [:], encoding: params, headers: self.authenticationHeader(user: user)).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode(CreateReflectionResponse.self, from: json)
                    callbackOk(res)
                }catch { }
            }
        }
    }
    
    func authorize(jobRequest: AuthorizationRequest, user: User?, callbackOk: @escaping (_ response: AuthorizationResponse) -> Void) {
        guard let user = user else { return }
        Alamofire.request(Endpoints.authorization, method: .post, parameters: jobRequest.dictionary, encoding: JSONEncoding.default, headers: self.authenticationHeader(user: user)).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode(AuthorizationResponse.self, from: json)
                    callbackOk(res)
                }catch { }
            }
        }
    }
    
    func confirmation(confirmationRequest: ConfirmationRequest, user: User?, callbackOk: @escaping (_ response: ConfirmationResponse) -> Void) {
        guard let user = user else { return }
        Alamofire.request(Endpoints.confirmation, method: .post, parameters: confirmationRequest.dictionary, encoding: JSONEncoding.default, headers: self.authenticationHeader(user: user)).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode(ConfirmationResponse.self, from: json)
                    callbackOk(res)
                }catch { }
            }
        }
    }
    
    
    func shareReflectionToGroup(shareRequest: ShareReflectionGroupRequest, user: User?, callbackOk: ((_ response: ShareReflectionGroupResponse) -> Void)?) {
        guard let user = user else { return }
        Alamofire.request(Endpoints.shareToGroup(reflectionId: shareRequest.reflectionId!), method: .post, parameters: shareRequest.dictionary, encoding: JSONEncoding.default, headers: self.authenticationHeader(user: user)).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode(ShareReflectionGroupResponse.self, from: json)
                    callbackOk?(res)
                }catch { }
            }
        }
    }
    
    func pages(pagesRequest: PagesRequest, user: User?, callbackOk: ((_ response: PageResponse?) -> Void)?) {
        guard let user = user else { return }
        Alamofire.request(Endpoints.pages(groupId: pagesRequest.groupId), method: .post, parameters: pagesRequest.dictionary, encoding: JSONEncoding.default, headers: self.authenticationHeader(user: user)).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode([PageResponse].self, from: json)
                    callbackOk?(res.filter { $0.title == "Job Description" }.first)
                }catch { }
            }
        }
    }
    
    
    var mobileApiKeyHeader: [String: String] {
        return ["x-atlas-mobile-api-key": Endpoints.mobileApiKey]
    }
    
    func authenticationHeader(user: User) -> [String: String]? {
        guard let key = user.authenticationKey else { return nil }
        return ["x-atlas-mobile-api-key": Endpoints.mobileApiKey, "Authorization": key,
                "x-atlas-mobile-app-version": "3.7.7(825)"]
    }
    
    func isOk(response: HTTPURLResponse?) -> Bool {
        guard let response = response else { return false }
        return 200...299 ~= response.statusCode
    }
    
    
}


extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}


