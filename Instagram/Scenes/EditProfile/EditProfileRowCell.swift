//
//  EditProfileRowCell.swift
//  Instagram
//
//  Created by alice singh on 01/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class EditProfileRowCell: UITableViewCell {
    enum RowType {
        case normal
        case gender
    }
    
    var rowType: RowType = .normal {
        didSet {
            if rowType == .gender {
                setupGenderUi()
            }
        }
    }
    
    
    lazy var label:  UILabel = {
        var label = UILabel()
        label.font = Fonts.helvetica.of(14)
        label.textColor = UIColor.flatGrayDark
        return label
    }()
    
    lazy var textField: UITextField = {
        var textfield = UITextField()
        textfield.backgroundColor = UIColor.flatWhite
        textfield.clearButtonMode  = .whileEditing
        textfield.autocorrectionType = .no
        textfield.font = Fonts.helveticaBold.of(16)
        textfield.borderStyle = .roundedRect
        textfield.setupDoneButton()
        return textfield
    }()
    
    fileprivate lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    fileprivate var genderArray = ["Male", "Female"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.selectionStyle = .none
        backgroundColor = UIColor.white
        self.contentView.addSubview(label)
        self.contentView.addSubview(textField)
    }
    
    func setUpConstraints() {
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(6)
            make.left.equalToSuperview().offset(16)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.left.equalTo(label)
            make.height.equalTo(34)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(6)
        }
    }
    
    func setupGenderUi() {
        textField.clearButtonMode  = .never
        textField.inputView = genderPicker
        
        // set default data
        textField.text = genderArray[0]
    }
}

extension EditProfileRowCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
}

extension EditProfileRowCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = genderArray[row]
    }
}
