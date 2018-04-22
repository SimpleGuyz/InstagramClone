//
//  QuoteDetailQuoteCell.swift
//  Instagram
//
//  Created by alice singh on 04/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class QuoteDetailQuoteCell: UITableViewCell {
    static let reuseId = " QuoteDetailQuoteCell"
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Fonts.helveticaBold.of(30)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
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
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(60)
        }
    }
    
    func setUpData(_ quote: Quote) {
        self.label.text = quote.quote
    }
}
