//
//  MyProfileAvatarCell.swift
//  Instagram
//
//  Created by alice singh on 07/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class MyProfileAvatarCell: UITableViewCell {
    lazy var avatarView: UIImageView = {
        var imageview = UIImageView()
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 50
        imageview.backgroundColor = UIColor.flatPowderBlue
        return imageview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.selectionStyle = .none
        self.contentView.addSubview(avatarView)
    }
    
    func setUpConstraints() {
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
}
