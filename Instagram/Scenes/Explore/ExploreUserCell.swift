//
//  ExploreUserCell.swift
//  Instagram
//
//  Created by Kaushal on 14/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class ExploreUserCell: UITableViewCell {
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setups()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpData(_ user: UserDetail) {
        guard let avatarUrl = user.avatarURL else { return  }
        self.avatarView.kf.setImage(with: URL(string: avatarUrl))
        self.nameLabel.text = user.fullname
    }
}

extension ExploreUserCell {
    func setups() {
        [avatarView, nameLabel].forEach(contentView.addSubview)
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(14)
            make.top.equalToSuperview().inset(10)
            make.size.equalTo(46)
            make.bottom.equalToSuperview().inset(14)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12)
            make.centerY.equalTo(avatarView)
        }
    }
}
