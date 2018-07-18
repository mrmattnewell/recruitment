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
    let sessionManager = SessionManager.shared()
    
    func login(username: String, password: String, loginOk: @escaping () -> Void, loginError: @escaping () -> Void) {
        let loginRequest = LoginRequest(username: username, password: password)
        irisApi.login(login: loginRequest, callbackOk: {[weak self] (loginResponse) in
            let user = loginResponse.user()
            user.password = password
            self?.sessionManager.user = user
            loginOk()
        }) {
            loginError()
        }
    }
}



protocol LoginInteractor {
    func login(username: String, password: String, loginOk: @escaping () -> Void, loginError: @escaping () -> Void) 
}



