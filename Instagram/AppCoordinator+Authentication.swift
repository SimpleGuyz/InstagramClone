//
//  AppCoordinator+Authentication.swift
//  Instagram
//
//  Created by Kaushal on 25/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

extension AppCoordinator: OnboardingControllerDelegate {
    func onboardingControllerDidSelectSignIn(_ controller: UIViewController) {
        let signInPage = SignInController()
        signInPage.delegate = self
        controller.present(signInPage, animated: true)
    }
    
    func onboardingControllerDidSelectSignUp(_ controller: UIViewController) {
        let signUpPage = SignupController()
        signUpPage.delegate = self
        controller.present(signUpPage, animated: true)
    }
}

extension AppCoordinator: SignInControllerDelegate {
    func signInControllerDoneSignIn(_ controller: UIViewController) {
        switchToDashboard()
    }
}

extension AppCoordinator: SignupControllerDelegate {
    func signUpControllerDoneSignup(_ controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        switchToDashboard()
    }
}

