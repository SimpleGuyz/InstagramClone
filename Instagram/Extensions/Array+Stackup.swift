//
//  Array+Stackup.swift
//  RandomExperiments
//
//  Created by Kaushal on 04/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension Array where Element: UIView {
    func stackup(axis: UILayoutConstraintAxis = .vertical, spacing: CGFloat = 10, alignment: UIStackViewAlignment = .center) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: self)
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        return stack
    }
}
