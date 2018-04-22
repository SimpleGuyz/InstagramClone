//
//  AppCoordinator+Feed.swift
//  Instagram
//
//  Created by Kaushal on 07/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension AppCoordinator: HomeControllerDelegate {
    func homeController(_ controller: UIViewController, didSelectUser userId: String) {
        let userPage = UserProfileController(userId: userId)
        userPage.delegate = self
        controller.navigationController?.pushViewController(userPage, animated: true)
    }
    
    func homeControllerDidSelectCreate(_ controller: UIViewController) {
        let createPage = CreateItemController()
        createPage.delegate = self
        let nav = UINavigationController(rootViewController: createPage)
        controller.present(nav, animated: true)
    }
}

extension AppCoordinator: CreateItemControllerDelegate {
    func createItemControllerDoneSuccessfully(_ controller: UIViewController) {
        controller.dismiss(animated: true)
    }
}


