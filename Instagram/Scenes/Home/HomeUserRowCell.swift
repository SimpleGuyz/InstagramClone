//
//  HomeUserRowCell.swift
//  Instagram
//
//  Created by Kaushal on 16/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import Kingfisher

class HomeUserRowCell: UITableViewCell {
    static let reuseId = "HomeUserRowCell"
    
    lazy var userAvatarView: UIImageView = {
        var imageview = UIImageView()
        //imageview.image = #imageLiteral(resourceName: "dog")
        imageview.layer.cornerRadius = 25
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.backgroundColor = UIColor.flatRed
        return imageview
    }()
    
    lazy var usernameLabel: UILabel = {
        var label = UILabel()
        label.text = "user"
        label.textColor = .darkGray
        label.font = Fonts.helveticaBold.of(18)
        return label
    }()
    
    lazy var placeNameLabel: UILabel = {
        var label = UILabel()
        label.text = "unknown place"
        label.textColor = .darkGray
        label.font = Fonts.helvetica.of(16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ item: FeedItem?) {
        guard let item = item else { return }
        self.usernameLabel.text = item.userFullname
        self.placeNameLabel.text = item.place
        let url = URL(string: item.userImageUrl ?? "")
        self.userAvatarView.kf.setImage(with: url)
    }
}

extension HomeUserRowCell {
    func setupViews() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubview(userAvatarView)
        setupContraint()
        
        setupStackForLabels()
    }
    
    func setupContraint() {
        userAvatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(50)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setupStackForLabels() {
        let stackLabels = UIStackView(arrangedSubviews: [usernameLabel, placeNameLabel])
        stackLabels.axis = .vertical
        stackLabels.spacing = 2
        stackLabels.alignment = .leading
        contentView.addSubview(stackLabels)
        
        stackLabels.snp.makeConstraints { (make) in
            make.centerY.equalTo(userAvatarView)
            make.left.equalTo(userAvatarView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().inset(40)
        }
    }
}


