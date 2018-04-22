//
//  SettingCell.swift
//  Instagram
//
//  Created by alice singh on 26/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    enum CellType {
        case edit
        case logout
    }
    
    var cellType: CellType = .edit {
        didSet {
            setUpCellType()
        }
    }
    
    lazy var editButton: UIButton = {
        var button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.flatTeal, for: .normal)
        button.setTitleColor(UIColor.flatYellow, for: .highlighted)
        button.titleLabel?.font = Fonts.helveticaBold.of(25)
        //if cellType == .logout { button.isHidden = true }
        return button
    }()
    
   lazy var logoutButton: UIButton = {
        var button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.flatTeal, for: .normal)
        button.setTitleColor(UIColor.flatYellow, for: .highlighted)
        button.titleLabel?.font = Fonts.helveticaBold.of(19)
        //if cellType == .edit { button.isHidden = true }
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.contentView.addSubview(editButton)
        self.contentView.addSubview(logoutButton)
    }
    
    func setUpConstraints() {
        editButton.snp.makeConstraints {(make) in
            make.top.bottom.equalToSuperview().inset(50)
            make.width.equalTo(100)
            make.center.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints {(make) in
            make.top.bottom.equalToSuperview().inset(50)
            make.width.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    func setUpCellType() {
        if cellType == .edit {
            self.logoutButton.isHidden = true
            self.editButton.isHidden = false
        } else if cellType == .logout {
            self.editButton.isHidden = true
            self.logoutButton.isHidden = false
        }
    }
}
