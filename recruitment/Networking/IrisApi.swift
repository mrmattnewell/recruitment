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
    
    func login(login: LoginRequest, callbackOk: @escaping (_ response: LoginResponse) -> Void) {
        Alamofire.request(Endpoints.login, method: .post, parameters: login.dictionary, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            guard self.isOk(response: response.response) else { return }
            if let json = response.result.value {
                do{
                    let res = try JSONDecoder().decode(LoginResponse.self, from: json)
                    callbackOk(res)
                }catch { }
            }
        }
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
