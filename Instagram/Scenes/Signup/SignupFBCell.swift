//
//  ProfilePageFBCell.swift
//  Instagram
//
//  Created by alice singh on 22/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class SignupFBCell: UITableViewCell {
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.selectionStyle = .none
        let stack = UIStackView(arrangedSubviews: [fbImageView, fbButton])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        contentView.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(40)
        }
        
        fbImageView.snp.makeConstraints { (make) in
            make.size.equalTo(30)
        }
    }
}
