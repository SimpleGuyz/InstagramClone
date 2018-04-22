//
//  MessageCell.swift
//  Instagram
//
//  Created by Kaushal on 05/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        label.font = Fonts.helveticaBold.of(16)
        label.textAlignment = .center
        //label.adjustsFontSizeToFitWidth = true
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

extension MessageCell {
    func setupViews() {
        contentView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func setData(_ message: Message) {
        self.contentLabel.text = message.content
    }
}
