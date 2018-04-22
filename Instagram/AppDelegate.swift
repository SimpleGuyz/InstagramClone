//
//  AppDelegate.swift
//  Instagram
//
//  Created by alice singh on 16/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        AppCoordinator.shared.start()
        
        return true
    }
}

