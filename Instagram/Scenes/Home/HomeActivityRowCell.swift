//
//  HomeActivityRowCell.swift
//  Instagram
//
//  Created by Kaushal on 16/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class HomeActivityRowCell: UITableViewCell {
    static let reuseId = "HomeActivityRowCell"
    
    lazy var likeButton: UIButton = {
        var button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeActivityRowCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        likeButton.snp.makeConstraints{(make) in
            make.left.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(26)
        }
        
        commentButton.snp.makeConstraints{(make) in
            make.left.equalTo(likeButton.snp.right).offset(10)
            make.centerY.equalTo(likeButton)
            make.size.equalTo(26)
        }
    }
}
