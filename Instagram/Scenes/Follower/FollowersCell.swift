//
//  FollowersCell.swift
//  Instagram
//
//  Created by alice singh on 20/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {
    lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 23
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.flatPowderBlue
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.helveticaBold.of(18)
        label.textColor = UIColor.flatBlackDark
        label.text = "KOi user"
        return label
    }()
    
    lazy var unFollowButton: UIButton = {
        var button = UIButton()
        button.setTitle("UnFollow", for: .normal)
        button.backgroundColor = UIColor.flatTeal
        button.setTitleColor(.red, for: .highlighted)
        button.titleLabel?.font = Fonts.helveticaBold.of(18)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.contentView.addSubview(avatarView)
        self.contentView.addSubview(nameLabel)
    }
    
    func setUpConstraints() {
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(14)
            make.width.equalTo(46)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().inset(14)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12)
            make.centerY.equalTo(avatarView)
        }
//
//        unFollowButton.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().inset(20)
//            make.centerY.equalTo(avatarView)
//            make.width.equalTo(100)
//            make.height.equalTo(26)
//        }
    }
}

extension FollowersCell {
    func setData(_ detail: UserDetail) {
        if let urlString = detail.avatarURL {
            self.avatarView.kf.setImage(with: URL(string: urlString))
        }
        
        nameLabel.text = detail.fullname
        
    }
}






