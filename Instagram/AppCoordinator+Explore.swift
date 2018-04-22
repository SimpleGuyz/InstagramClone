//
//  AppCoordinator+Explore.swift
//  Instagram
//
//  Created by Kaushal on 17/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension AppCoordinator: ExploreControllerDelegate {
    func exploreController(_ controller: UIViewController, didSelectQuote quote: Quote) {
        let quoteDetailPage = QuoteDetailController(quote)
        controller.navigationController?.pushViewController(quoteDetailPage, animated: true)
    }
    
    func exploreController(_ controller: UIViewController, didSelectUser userId: String) {
        let userPage = UserProfileController(userId: userId)
        userPage.delegate = self
        controller.navigationController?.pushViewController(userPage, animated: true)
    }
}

extension AppCoordinator: UserProfileControllerDelegate {
    func userProfileController(_ controller: UIViewController, didSelectFollowers userId: String) {
        let followerPage = FollowersController(userId: userId)
        followerPage.delegate = self
        controller.navigationController?.pushViewController(followerPage, animated: true)
    }
    
    func userProfileController(_ controller: UIViewController, didSelectFollowings userId: String) {
        let followerPage = FollowersController(userId: userId, style: .following)
        followerPage.delegate = self
        controller.navigationController?.pushViewController(followerPage, animated: true)
    }
    
    func userProfileController(_ controller: UIViewController, didSelectAvatar url: URL) {
        let imagePage = UserAvatarDetailController(url: url)
        imagePage.modalTransitionStyle = .crossDissolve
        controller.present(imagePage, animated: true)
    }
    
    func userProfileController(_ controller: UIViewController, didSelectConversation conversationId: String) {
        let messagePage = MessageController(conversationid: conversationId)
        messagePage.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(messagePage, animated: true)
    }
}

extension AppCoordinator: FollowersControllerDelegate {
    func followersControllerdidSelectUser(_ controller: UIViewController, _ id: String) {
        let userPage = UserProfileController(userId: id)
        userPage.delegate = self
        controller.navigationController?.pushViewController(userPage, animated: true)
    }
}

    
    

