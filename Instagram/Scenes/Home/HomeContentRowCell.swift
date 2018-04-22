//
//  HomeContentRowCell.swift
//  Instagram
//
//  Created by Kaushal on 16/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class HomeContentRowCell: UITableViewCell {
    static let reuseId = "HomeContentRowCell"
    
    lazy var quoteLabel: UILabel = {
        var quotelabel = UILabel()
        //quotelabel.text = "Chase your dreams But first find out the Right Map"
        quotelabel.textAlignment = .center
        quotelabel.font = Fonts.helveticaBold.of(30)
        quotelabel.textColor = UIColor.flatGray
        quotelabel.numberOfLines = 0
        return quotelabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ item: FeedItem) {
        self.quoteLabel.text = item.quote
    }
}

extension HomeContentRowCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(quoteLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        quoteLabel.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
}
