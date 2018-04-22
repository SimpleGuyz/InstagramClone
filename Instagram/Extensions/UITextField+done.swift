//
//  UITextField+done.swift
//  Instagram
//
//  Created by Kaushal on 01/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension UITextField {
    func setupDoneButton() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 1, height: 34))
        let doneBbi = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(resignFirstResponder))
        let wideBbi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([wideBbi, doneBbi], animated: false)
        self.inputAccessoryView = bar
    }
}
