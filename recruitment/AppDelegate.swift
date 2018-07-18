//
//  AppDelegate.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 19/06/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        var controller: UIViewController?
        let irisApi: IrisApi = IrisApi()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        do{
            let user = try SessionManager.shared().getCredentials()
            let request = LoginRequest(username: user.username!, password: user.password!)
            irisApi.login(login: request, callbackOk: { (response) in
                SessionManager.shared().user = response.user()
                self.showJobs()
            }) {
                self.showLogin()
            }
        }catch{
            self.showLogin()
        }
        
        return false
    }
    
    func showLogin(){
        let controller = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
        
    }
    
    func showJobs(){
        let controller = UIStoryboard(name: "JobsStoryboard", bundle: Bundle.main).instantiateInitialViewController()
        self.window?.rootViewController = controller
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }


}

