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
            
        }
    }
    
    private static var sharedSessionManager: SessionManager = {
        let sessionManager = SessionManager()
        return sessionManager
    }()
    
    private init(){
        self.user = try? getCredentials()
    }
    
    func setCredentials(user: User) {
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
        self.user = user
    }
    
    func getCredentials() throws -> User {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Endpoints.host,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        let user = User()
        user.username = account
        user.password = password
        return user
    }

    class func shared() -> SessionManager {
        return sharedSessionManager
    }
}


enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
