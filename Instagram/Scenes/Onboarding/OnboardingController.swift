//
//  OnboardingController.swift
//  Instagram
//
//  Created by Kaushal on 23/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol OnboardingControllerDelegate: class {
    func onboardingControllerDidSelectSignIn(_ controller: UIViewController)
    func onboardingControllerDidSelectSignUp(_ controller: UIViewController)
}

class OnboardingController: UIViewController {
    weak var delegate: OnboardingControllerDelegate?
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = Fonts.helveticaBold.of(20)
        button.setTitleColor(UIColor.flatGrayDark, for: .normal)
        button.setTitleColor(UIColor.flatGray, for: .highlighted)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = Fonts.helveticaBold.of(20)
        button.setTitleColor(UIColor.flatGrayDark, for: .normal)
        button.setTitleColor(UIColor.flatGray, for: .highlighted)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
}

extension OnboardingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [signInButton, signupButton])
        stack.spacing = 40
        stack.axis = .vertical
        self.view.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

extension OnboardingController {
    @objc func handleSignup() {
        delegate?.onboardingControllerDidSelectSignUp(self)
    }
    
    @objc func handleSignIn() {
        delegate?.onboardingControllerDidSelectSignIn(self)
    }
}



