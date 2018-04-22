//
//  EditProfileAvatarCell.swift
//  Instagram
//
//  Created by alice singh on 01/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class EditProfileAvatarCell: UITableViewCell {
    
   lazy var avatarView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.flatWhite
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var editAvatarButton: UIButton = {
        var button = UIButton()
        button.setTitle("Change photo", for: .normal)
        button.setTitleColor(UIColor.flatBlue, for: .normal)
        button.setTitleColor(UIColor.flatGray, for: .highlighted)
        button.titleLabel?.font =  Fonts.helveticaBold.of(16)
        return button
    }()
    
    func setUpImage(_ image: UIImage) {
        self.avatarView.image = image
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpViews() {
        selectionStyle = .none
        backgroundColor = UIColor.white
        self.contentView.addSubview(avatarView)
        self.contentView.addSubview(editAvatarButton)
    }
    
    func setUpConstraints() {
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        editAvatarButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}


