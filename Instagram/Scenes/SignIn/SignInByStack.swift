//
//  SignInByStack.swift
//  Instagram
//
//  Created by alice singh on 23/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class SignInByStack: UIViewController {
    lazy var instagramlabel: UILabel = {
        var label = UILabel()
       label.text = "Instagram"
        label.font = Fonts.helveticaBold.of(34)
        label.textColor = .white
        return label
    }()
    
    lazy var topView: UIView = {
        var frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.height)/5.0 )
        var view = UIView(frame: frame)
        view.backgroundColor = UIColor.flatMagenta
        return view
    }()
    
    lazy var emailField: UITextField = {
        var textfield = UITextField(frame: .zero)
        textfield.placeholder = "Email"
        textfield.backgroundColor = UIColor.flatWhite
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var passwordField: UITextField = {
        var textfield = UITextField(frame: .zero)
        textfield.placeholder = "Password"
        textfield.backgroundColor = UIColor.flatWhite
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var userNameField: UITextField = {
        var textfield = UITextField(frame: .zero)
        textfield.placeholder = "Name"
        textfield.backgroundColor = UIColor.flatWhite
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var fieldStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [emailField,userNameField,passwordField])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 10
        return view
    }()
    
    lazy var createButton: UIButton = {
        var button = UIButton(frame: .zero)
        button.setTitle("Create", for: .normal)
        button.backgroundColor = UIColor.flatBlue
        button.titleLabel?.font = Fonts.helvetica.of(22)
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var fbImageView: UIImageView = {
        var imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "facebook")
        return imageview
    }()
    
    lazy var  fbButton: UIButton = {
        var button = UIButton(frame: .zero)
        button.setTitle("Log in with Facebook", for: .normal)
        button.setTitleColor(UIColor.flatBlue, for: .normal)
        button.setTitleColor(UIColor.flatWhite, for: .highlighted)
        button.titleLabel?.textAlignment = .left
        //button.backgroundColor = UIColor.flatGray
        button.titleLabel?.font = Fonts.helvetica.of(16)
        return button
    }()
    
    lazy var fbStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fbImageView, fbButton])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        return stack
    
    }()
}

extension SignInByStack {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    func setUpViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(topView)
        self.view.addSubview(fieldStackView)
        self.topView.addSubview(instagramlabel)
        self.view.addSubview(createButton)
        self.view.addSubview(fbStackView)
    }
    
    func setUpConstraints() {
        instagramlabel.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
        }
        
        fieldStackView.snp.makeConstraints {(make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        emailField.snp.makeConstraints {(make) in
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(30)
            
        }
        
        userNameField.snp.makeConstraints {(make) in
            make.top.equalTo(emailField.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(30)
       }
        passwordField.snp.makeConstraints {(make) in
            make.top.equalTo(userNameField.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(8)
       }
        createButton.snp.makeConstraints { (make) in
            make.top.equalTo(fieldStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(48)
           //make.bottom.equalToSuperview().inset(10)
        }
        
       
        fbStackView.snp.makeConstraints { (make) in
            make.top.equalTo(createButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        fbImageView.snp.makeConstraints { (make) in
            make.size.equalTo(30)
        }
   }
}
