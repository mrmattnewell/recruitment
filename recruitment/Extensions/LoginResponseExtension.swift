//
//  LoginResponseExtension.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


extension LoginResponse {
    func user() -> User {
        let user = User()
        user.authenticationKey = self.login.authorization.key
        return user
    }
}
