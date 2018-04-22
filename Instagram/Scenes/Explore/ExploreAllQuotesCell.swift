//
//  ExploreAllQuotesCell.swift
//  Instagram
//
//  Created by alice singh on 03/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class ExploreAllQuotesCell: UICollectionViewCell {
    
    lazy var quoteLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helvetica.of(14)
        label.numberOfLines = 0
        label.text = "Alice Singh"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.contentView.addSubview(quoteLabel)
    }
    
    func setUpConstraints() {
        quoteLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
        }
    }
    
    func setUpData(_ quote: Quote) {
        self.quoteLabel.text = quote.quote
    }
}
