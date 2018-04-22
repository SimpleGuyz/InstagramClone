//
//  MyProfileRowcCell.swift
//  Instagram
//
//  Created by alice singh on 07/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class MyProfileRowCell: UITableViewCell {
    lazy var label: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(22)
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
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
        self.selectionStyle = .none
        self.contentView.addSubview(label)
    }
    
    func setUpConstraints() {
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
    }
}
