//
//  Interactor.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class LoginInteractorImpl: LoginInteractor {
    
    let irisApi = IrisApi()
    
    func login(username: String, password: String, loginOk: @escaping () -> Void) {
        let loginRequest = LoginRequest(username: username, password: password)
        irisApi.login(login: loginRequest) { (loginResponse) in
            loginOk()
        }
    }
}



protocol LoginInteractor {
    func login(username: String, password: String, loginOk: @escaping () -> Void)
}



