//
//  MessageRightCell.swift
//  Instagram
//
//  Created by Kaushal on 05/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class MessageRightCell: UITableViewCell {
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.flatPowderBlue
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = Fonts.helveticaBold.of(16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageRightCell {
    func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(contentLabel)
        
        bubbleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.greaterThanOrEqualToSuperview().inset(80)
            make.right.equalToSuperview().inset(12)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setData(_ message: MessageViewModel) {
        self.contentLabel.text = message.content
    }
}
