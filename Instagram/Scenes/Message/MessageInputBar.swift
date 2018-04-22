//
//  MessageInputBar.swift
//  Instagram
//
//  Created by Kaushal on 05/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import SnapKit
import SZTextView

protocol MessageInputBarDelegate: class {
    func messageInputBar(bar: MessageInputBar, didSendMessage message: String)
}

final class MessageInputBar: UIView {
    weak var delegate: MessageInputBarDelegate?
    
    var textViewRightConstraint: Constraint?
    
    lazy var textView: SZTextView = {
        let textView = SZTextView()
        textView.font = Fonts.helveticaBold.of(16)
        //textField.textAlignment = .center
        textView.placeholder = "Type here.."
        textView.textColor = UIColor.darkGray
        //textView.borderStyle = .roundedRect
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 1
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        var button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = Fonts.helveticaBold.of(16)
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageInputBar {
    fileprivate func setupViews() {
        self.addSubviews([sendButton, textView])
        
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(20)
            self.textViewRightConstraint = make.right.equalToSuperview().inset(25).constraint   ///.inset(100)
            make.height.greaterThanOrEqualTo(30)
            make.height.lessThanOrEqualTo(160)
            make.bottom.equalToSuperview().inset(12)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(30)
        }
    }
    
    @objc func handleSendButton() {
        delegate?.messageInputBar(bar: self, didSendMessage: textView.text)
        textView.text = ""
        changeTextViewToFullFrame()
    }
}

extension MessageInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            changeTextViewToShortFrame()
        } else {
            changeTextViewToFullFrame()
        }
    }
    
    fileprivate func changeTextViewToFullFrame() {
        textViewRightConstraint?.update(inset: 25)
        
        springAnimation {
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func changeTextViewToShortFrame() {
        textViewRightConstraint?.update(inset: 100)
        
        springAnimation {
            self.layoutIfNeeded()
        }
    }
}

func springAnimation(animation: @escaping () -> Void) {
    UIView.animate(withDuration: 0.65,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0.7,
                   options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction],
                   animations: {
                    animation()
    }, completion: nil)
}
