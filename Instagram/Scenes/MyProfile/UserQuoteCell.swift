//
//  UserQuoteCell.swift
//  Instagram
//
//  Created by Kaushal on 12/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class UserQuoteCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Some quotes"
        label.numberOfLines = 3
        label.font = Fonts.helvetica.of(14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserQuoteCell {
    
    func setupViews() {
        contentView.addSubview(label)
        layer.cornerRadius = 4.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.flatGrayDark.cgColor
    }
    
    func setupContraints() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
        }
    }
    
    func setData(_ item: Quote) {
        self.label.text = item.quote
    }
}
