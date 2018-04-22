//
//  UIViewController+addSubviews.swift
//  Instagram
//
//  Created by Kaushal on 23/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach(addSubview)
    }
}
