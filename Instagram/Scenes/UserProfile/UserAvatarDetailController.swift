//
//  UserAvatarDetailController.swift
//  Instagram
//
//  Created by Kaushal on 23/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class UserAvatarDetailController: UIViewController {
    var imageUrl: URL
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    init(url: URL) {
        self.imageUrl = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserAvatarDetailController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        loadImage()
    }
    
    func setups() {
        self.view.backgroundColor = UIColor.flatWhite
        
        // gestures
        //let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        //imageView.addGestureRecognizer(gesture)
        
        self.view.addSubview(imageView)
        self.view.addSubview(closeBtn)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(40)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
    }
    
    func loadImage() {
        imageView.kf.setImage(with: self.imageUrl)
    }
}

extension UserAvatarDetailController {
    @objc func handleClose() {
        dismiss(animated: true)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        dismiss(animated: true)
    }
}




