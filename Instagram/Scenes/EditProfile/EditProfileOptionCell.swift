//
//  EditProfileOptionCell.swift
//  Instagram
//
//  Created by Kaushal on 06/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class EditProfileOptionCell: UITableViewCell {
    enum Kind {
        case field
        case image
        case both
    }
    
    var kind: Kind = .both { //default is `both`
        didSet {
            switch kind {
            case .field:
                textField.isHidden = false
                avatarView.isHidden = true
            case .image:
                textField.isHidden = true
                avatarView.isHidden = false
            case .both:
                textField.isHidden = false
                avatarView.isHidden = false
            }
        }
    }
    
    
    lazy var textField: UITextField = UITextField()
    lazy var avatarView: UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProfileOptionCell {
    func setupViews() {
        let views: [UIView] = [textField, avatarView]
        let stack = views.stackup(axis: .vertical, spacing: 10, alignment: .leading)
        contentView.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        // text field constraints
        
        // avatarViews constraints
        
    }
}
