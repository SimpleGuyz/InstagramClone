//
//  ProfilePageSignUpCell.swift
//  Instagram
//
//  Created by alice singh on 22/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class SignupFieldCell: UITableViewCell {
    lazy var textField: UITextField = {
        var textfield = UITextField(frame: .zero)
        //textfield.placeholder = ""
        textfield.backgroundColor = UIColor.flatWhite
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        setUpViews()
        setUpConstaints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  setUpViews() {
        self.selectionStyle = .none
        self.contentView.addSubview(textField)
    }
    
    func setUpConstaints() {
        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
