//
//  CreateItemRowCell.swift
//  Instagram
//
//  Created by alice singh on 27/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class CreateItemRowCell: UITableViewCell {
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = Fonts.helveticaBold.of(18)
        textField.textAlignment = .center
        textField.placeholder = "Place"
        textField.textColor = UIColor.darkGray
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.flatWhite
        return textField
    }()
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "gps"), for: .normal)
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
        self.contentView.addSubview(textField)
        self.contentView.addSubview(button)
    }
    
    func setUpConstraints() {
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(80)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.left.equalTo(textField.snp.right).offset(10)
            make.size.equalTo(32)
        }
    }
}
