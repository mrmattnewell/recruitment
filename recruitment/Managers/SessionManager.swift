//
//  SessionManager.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation


class SessionManager {
    
    var user: User?
    
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
