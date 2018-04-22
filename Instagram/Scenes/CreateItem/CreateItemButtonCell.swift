//
//  CreateItemButtonCell.swift
//  Instagram
//
//  Created by alice singh on 27/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class CreateItemButtonCell: UITableViewCell {
    lazy var publishButton: UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        button.setTitle("Publish", for: .normal)
        button.titleLabel?.font = Fonts.helveticaBold.of(22)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.flatWhite, for: .highlighted)
        button.backgroundColor = UIColor.flatPurple
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
        self.contentView.addSubview(publishButton)
    }
    
    func setUpConstraints() {
        publishButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(60)
            make.height.equalTo(46)
        }
    }
}


    

