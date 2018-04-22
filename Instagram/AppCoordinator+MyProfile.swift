//
//  AppCoordinator+Edit.swift
//  Instagram
//
//  Created by alice singh on 08/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

extension AppCoordinator: MyProfileControllerDelegte {
    func myProfileControllerDidSelectSetting(_ controller: UIViewController) {
        let settingPage = SettingsController()
        settingPage.delegate = self
        controller.navigationController?.pushViewController(settingPage, animated: true)
    }
    
    func myprofileControllerDidClickFollowingButton(_ controller: UIViewController) {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return }
        let followersPage = FollowersController(userId: selfUserId, style: .following)
        followersPage.delegate = self
        controller.navigationController?.pushViewController(followersPage, animated: true)
    }
    
   func myProfileControllerDidClickFollowersButton(_ controller: UIViewController) {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return }
        let followersPage = FollowersController(userId: selfUserId)
        followersPage.delegate = self
        controller.navigationController?.pushViewController(followersPage, animated: true)
    }
    
    func myProfileController(_ controller: UIViewController, didSelectAvatar url: URL) {
        let imagePage = UserAvatarDetailController(url: url)
        imagePage.modalTransitionStyle = .crossDissolve
        controller.present(imagePage, animated: true)
    }
    
}

extension AppCoordinator: EditProfileControllerDelegate {
    func editProfileControllerDidDismiss(_ controller: UIViewController) {
        controller.dismiss(animated: true)
    }
}





