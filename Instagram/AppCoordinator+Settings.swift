//
//  AppCoordinator+Settings.swift
//  Instagram
//
//  Created by alice singh on 26/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension AppCoordinator: SettingControllerDelegate {
    func settingControllerDidSelectEdit(_ controller: UIViewController) {
        let editPage = EditProfileController()
        editPage.delegate = self
        let navigationController = UINavigationController(rootViewController: editPage)
        controller.present(navigationController, animated: true, completion: nil)
    }
    
    func settingControllerDidLogout(_ controller: UIViewController) {
        reset()
    }
}
