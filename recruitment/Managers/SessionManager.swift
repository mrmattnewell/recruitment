//
//  SessionManager.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class SessionManager {
    
    var user: User? {
        didSet{
            guard let user = self.user else {
                return
            }
            let account = user.username
            let password = user.password?.data(using: String.Encoding.utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: account,
                                        kSecAttrServer as String: Endpoints.host,
                                        kSecValueData as String: password]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                //throw KeychainError.unhandledError(status: status)
                print("Error saving user")
                return
            }
        }
    }
    
    private static var sharedSessionManager: SessionManager = {
        let sessionManager = SessionManager()
        return sessionManager
    }()
    
    private init(){
        
    }

    class func shared() -> SessionManager {
        return sharedSessionManager
    }
}
