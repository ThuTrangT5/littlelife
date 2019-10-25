//
//  AppDelegate.swift
//  LittleLife
//
//  Created by ThuTrangT5 on 10/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func gobackLoginScreen(message: String?) {
        
        if let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC") as? ViewController {
            self.changeRootViewTo(viewController: loginVC)
            
            if let msg = message {
                loginVC.showErrorMessage(message: msg)
            }
        }
    }
    
    func changeRootViewTo(viewController: UIViewController) {
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = viewController
    }
    
}

