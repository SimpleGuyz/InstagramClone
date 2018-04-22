//
//  AppCoordinator.swift
//  Instagram
//
//  Created by Kaushal on 24/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class AppCoordinator {
    static var shared = AppCoordinator()
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    private init() {}
    
    func start() {
        if Auth.auth().currentUser != nil {
            switchToDashboard()
        } else {
            switchToOnboarding()
        }
    }
    
    func reset() {
        switchToOnboarding()
    }
    
    func switchToDashboard() {
        let homePage = HomeController()
        homePage.delegate = self
        //homePage.onDidSelectUser = { userId in
        //    let userPage = UserProfileController(userId: userId)
        //    homePage.navigationController?.pushViewController(userPage, animated: true)
        //}
        
        // home
        let homeNav = UINavigationController(rootViewController: homePage)
        homeNav.tabBarItem.image = #imageLiteral(resourceName: "feedHash")
        homeNav.tabBarItem.title = "Feed"
        
        // search
        let searchPage = ExploreController()
        searchPage.delegate = self
        let searchNav = UINavigationController(rootViewController: searchPage)
        searchNav.tabBarItem.image = #imageLiteral(resourceName: "search")
        searchNav.tabBarItem.title = "Search"
        
        // conversations
        let conversationsPage = ConversationsController()
        conversationsPage.delegate = self
        let conversationsNav = UINavigationController(rootViewController: conversationsPage)
        conversationsNav.tabBarItem.image = #imageLiteral(resourceName: "chatIcon")
        conversationsNav.tabBarItem.title = "Message"
        conversationsNav.tabBarItem.badgeValue = "5"
        
        // profile
        let myProfilePage = MyProfileController()
        myProfilePage.delegate = self
        let myProfileNav = UINavigationController(rootViewController: myProfilePage)
        myProfileNav.tabBarItem.image = #imageLiteral(resourceName: "mask")
        myProfileNav.tabBarItem.title = "Profile"
        
        let all = [
            homeNav,
            searchNav,
            conversationsNav,
            myProfileNav
        ]
        
        let tabController = UITabBarController()
        tabController.setViewControllers(all, animated: true)
        
        self.window?.rootViewController = tabController
        self.window?.makeKeyAndVisible()
    }
    
    func switchToOnboarding() {
        let onbPage = OnboardingController()
        onbPage.delegate = self
        self.window?.rootViewController = onbPage
        self.window?.makeKeyAndVisible()
    }
}


