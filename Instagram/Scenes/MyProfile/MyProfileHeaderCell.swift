//
//  MyProfileHeaderCell.swift
//  Instagram
//
//  Created by Kaushal on 12/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit



class MyProfileHeaderCell: UICollectionViewCell {
    lazy var avatarView: UIImageView = {
        var imageview = UIImageView()
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 50
        imageview.backgroundColor = UIColor.flatPowderBlue
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    lazy var bioLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(16)
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var genderLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(16)
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(16)
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var followButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.flatTeal
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(UIColor.flatPink, for: .highlighted)
        button.titleLabel?.font = Fonts.helveticaBold.of(16)
        button.layer.cornerRadius = 9
        return button
    }()
    
    
    lazy var postsCountLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(26)
        label.text = "0"
        label.backgroundColor = .clear
        return label
    }()
    lazy var postsButtton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.flatGrayDark, for: .normal)
        button.setTitle("Posts", for: .normal)
        button.setTitleColor(UIColor.flatBlue, for: .highlighted)
        button.titleLabel?.font = Fonts.helveticaBold.of(16)
        return button
    }()
    
    
    lazy var followersCountLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(26)
        label.text = "0"
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var followersButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.flatGrayDark, for: .normal)
        button.setTitle("followers", for: .normal)
        button.setTitleColor(UIColor.flatBlue, for: .highlighted)
        button.titleLabel?.font = Fonts.helvetica.of(16)
        return button
    }()
    
    lazy var followingCountLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(26)
        label.text = "0"
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var followingButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.flatGrayDark, for: .normal)
        button.setTitle("following", for: .normal)
        button.setTitleColor(UIColor.flatBlue, for: .highlighted)
        button.titleLabel?.font = Fonts.helvetica.of(16)
        return button
    }()
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyProfileHeaderCell {
    func setupViews() {
        contentView.addSubview(avatarView)
        contentView.addSubview(followButton)
        contentView.addSubview(bioLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(emailLabel)
      
      
        setUpStack()
    }
    
    func setupContraints() {
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(100)
            //make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        
        bioLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(35)
        }
        
        genderLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
        }
        
        emailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(genderLabel.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }

    }
}


extension MyProfileHeaderCell {
    func setUpStack() {
        let postStackLabels = UIStackView(arrangedSubviews: [postsCountLabel, postsButtton])
        postStackLabels.axis = .vertical
        postStackLabels.alignment = .center
        //postStackLabels.spacing = 0
       
        
        let followerStackLabels = UIStackView(arrangedSubviews: [followersCountLabel,followersButton])
        followerStackLabels.axis = .vertical
        followerStackLabels.alignment = .center
        //followerStackLabels.spacing = 2
       
        
        let followingStackLabels = UIStackView(arrangedSubviews: [followingCountLabel,followingButton])
        followingStackLabels.axis = .vertical
        followingStackLabels.alignment = .center
        //followingStackLabels.spacing = 2
        
        
        let commonStack = UIStackView(arrangedSubviews: [followerStackLabels, followingStackLabels])
        commonStack.axis = .horizontal
        commonStack.alignment = .firstBaseline
       // commonStack.spacing = 10
        self.contentView.addSubview(commonStack)
        
        commonStack.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView).offset(10)
            make.left.equalTo(avatarView.snp.right).offset(20)
            make.right.equalToSuperview().inset(30)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.top.equalTo(commonStack.snp.bottom).offset(8)
            make.centerX.equalTo(commonStack)
            make.width.equalTo(200)
            make.height.equalTo(28)
        }
     }
}
extension MyProfileHeaderCell {
    func setData(_ detail: UserDetail?, amIFollowing: Bool = false) {
        guard let detail = detail else { return }
        
        if amIFollowing == true {
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
        }
        
        self.bioLabel.text = detail.bio
        self.genderLabel.text = detail.gender
        self.emailLabel.text = detail.email
        
        if let urlString = detail.avatarURL {
            let url = URL(string: urlString)
            avatarView.kf.setImage(with: url)
        }
    }
    
    func setStats(followers: Int, followings: Int) {
        self.followersCountLabel.text = "\(followers)"
        self.followingCountLabel.text = "\(followings)"
    }
}
