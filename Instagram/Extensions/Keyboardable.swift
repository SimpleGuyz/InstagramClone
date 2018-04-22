//
//  UIViewController+KeyboardHandle.swift
//  RandomExperiments
//
//  Created by Kaushal on 02/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit


protocol Keyboardable: class {
    func keyboardWillShow(height: CGFloat, duration: Double, curveAnimation: UInt)
    func keyboardWillHide(duration: Double, curveAnimation: UInt)
}

extension Keyboardable where Self: UIViewController {
    
    func subscribeKeyboardEvents() {
        weak var delegate: Keyboardable? = self
    
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else { return }
            guard let  frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
            let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt) ?? 7
            
            delegate?.keyboardWillShow(height: frame.height, duration: duration, curveAnimation: curve)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            let userInfo = notification.userInfo
            let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
            let curve = (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt) ?? 7
            
            delegate?.keyboardWillHide(duration: duration, curveAnimation: curve)
        }
    }
}






