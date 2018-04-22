//
//  ConversationsCell.swift
//  Instagram
//
//  Created by alice singh on 09/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class ConversationsCell: UITableViewCell {
    static let reuseId = "ConversationsCell"
    
    lazy var AvatarView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.flatWhite
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(18)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helvetica.of(15)
          label.textColor = UIColor.flatGrayDark
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.text = "00:00"
        label.font = Fonts.helvetica.of(14)
        return label
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
        self.contentView.addSubview(AvatarView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(timeLabel)
    }
    
    func setUpConstraints() {
        AvatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().inset(20)
            make.size.equalTo(60)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(AvatarView.snp.right).offset(20)
            make.top.equalTo(AvatarView.snp.top).offset(6)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(AvatarView.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().inset(25)
        }

        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.top)
            make.right.equalToSuperview().inset(15)
        }
    }
}

extension ConversationsCell {
    func setUpData(_ conversation: ConversationShort) {
        if let urlString = conversation.oppoDetail?.avatarURL {
            let url = URL(string: urlString)
            self.AvatarView.kf.setImage(with: url)
        }
        
        self.nameLabel.text = conversation.oppoDetail?.fullname
        self.messageLabel.text = conversation.lastMessage?.content
        if let time = conversation.lastMessage?.time {
            let date = NSDate(timeIntervalSince1970: TimeInterval(time)!)
            self.timeLabel.text = date.timeAgo()
        }
    }
}

