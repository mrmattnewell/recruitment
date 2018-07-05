//
//  LoginPresenter.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class LoginPresenter {
    
    var interactor: LoginInteractor!
    let view: LoginView
    
    init(view: LoginView) {
        self.view = view
    }

    func login(username: String, password: String) {
        interactor.login(username: username, password: password){
            self.view.loginOk()
        }
    }
}
