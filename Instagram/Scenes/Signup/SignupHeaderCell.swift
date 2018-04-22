//
//  ProfilePageCell.swift
//  Instagram
//
//  Created by alice singh on 22/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class SignupHeaderCell: UITableViewCell {
    lazy var instagramLabel: UILabel = {
        var label = UILabel()
        label.text = "Instagram"
        label.font = Fonts.helveticaBold.of(34)
        label.textColor = .white
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SignupHeaderCell {
    func setUpViews() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.flatMagenta
        self.contentView.addSubviews([instagramLabel, closeButton])
    }
    
    func setUpContraints() {
        instagramLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(26)
        }
    }
}



