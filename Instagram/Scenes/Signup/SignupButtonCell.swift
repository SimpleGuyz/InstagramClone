//
//  ProfilePageButtonCell.swift
//  Instagram
//
//  Created by alice singh on 22/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class SignupButtonCell: UITableViewCell {
    lazy var createButton: UIButton = {
        var button = UIButton(frame: .zero)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(UIColor.flatPinkDark, for: .highlighted)
        button.backgroundColor = UIColor.flatBlue
        button.titleLabel?.font = Fonts.helvetica.of(22)
        button.layer.cornerRadius = 4
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
        self.selectionStyle = .none
        self.contentView.addSubview(createButton)
    }
    
    func setUpConstraints() {
        createButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
}
