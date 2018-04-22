//
//  CreateItemQuoteCell.swift
//  Instagram
//
//  Created by alice singh on 27/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit



class CreateItemQuoteCell: UITableViewCell {
    lazy var textView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = UIColor.flatPowderBlue
        textView.layer.cornerRadius = 10
        textView.font = Fonts.helveticaBold.of(26)
        return textView
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
        self.contentView.addSubview(textView)
    }
    
    func setUpConstraints() {
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(180)
            make.bottom.equalToSuperview().offset(5)
        }
    }
}


