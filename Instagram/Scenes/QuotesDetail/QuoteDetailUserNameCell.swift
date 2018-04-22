//
//  QuoteDetailUserNameCell.swift
//  Instagram
//
//  Created by alice singh on 05/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class QuoteDetailUserNameCell: UITableViewCell {
    static let reuseId = "QuoteDetailUserNameCell"
    
    lazy var userFullName: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.helveticaBold.of(20)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.selectionStyle = .none
        self.contentView.addSubview(userFullName)
    }
    
    func setUpConstraints() {
        userFullName.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(30)
            make.top.bottom.equalToSuperview().inset(30)
        }
    }
    
    func setUpData(_ detail: UserDetail?) {
        if let detail = detail {
            self.userFullName.text = detail.fullname
        }
    }
}
