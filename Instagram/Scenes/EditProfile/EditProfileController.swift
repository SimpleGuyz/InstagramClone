//
//  EditProfileController.swift
//  Instagram
//
//  Created by alice singh on 28/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import PromiseKit

protocol EditProfileControllerDelegate: class {
    func editProfileControllerDidDismiss(_ controller: UIViewController)
}

class EditProfileController: UIViewController {
    weak var delegate: EditProfileControllerDelegate?
    
    let imageKey = "ImageKey"
    
    lazy var tableView: UITableView = {
        var tableview = UITableView()
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 50
        tableview.backgroundColor = .clear
        //tableview.keyboardDismissMode = .onDrag
        tableview.dataSource = self
        //tableview.delegate = self
        tableview.tableFooterView = UIView()
        return tableview
    }()
    
    lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.trackTintColor = UIColor.flatWhite
        bar.progressTintColor = UIColor.flatGrayDark
        bar.layer.cornerRadius = 4
        bar.isHidden = true
        return bar
    }()
    
    lazy var avartarCell: EditProfileAvatarCell = {
        var cell = EditProfileAvatarCell()
        cell.editAvatarButton.addTarget(self, action: #selector(importImages), for: .touchUpInside)
        return cell
    }()
    
    lazy var usernameCell: EditProfileRowCell = {
        var cell = EditProfileRowCell()
        cell.label.text = "UserName"
        return cell
    }()
    
    lazy var nameCell: EditProfileRowCell = {
        var cell = EditProfileRowCell()
        cell.label.text = "Name"
        return cell
    }()
    
    lazy var bioCell: EditProfileRowCell = {
        var cell = EditProfileRowCell()
        cell.label.text = "Bio"
        return cell
    }()
    
    lazy var genderCell: EditProfileRowCell = {
        var cell = EditProfileRowCell()
        cell.label.text = "Gender"
        cell.rowType = .gender
        return cell
    }()
    
    lazy var emailCell: EditProfileRowCell = {
        var cell = EditProfileRowCell()
        cell.label.text = "Email"
        cell.textField.isUserInteractionEnabled = false
        return cell
    }()
    
   lazy var cells: [UITableViewCell] = [self.avartarCell,
                                         self.nameCell,
                                         self.bioCell,
                                         self.genderCell,
                                         self.emailCell]
}

extension EditProfileController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}

extension EditProfileController {
    func keyboardWillShow(height: CGFloat, duration: Double, curveAnimation: UInt) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
    }
    
    func keyboardWillHide(duration: Double, curveAnimation: UInt) {
        tableView.contentInset = .zero
    }
}

extension EditProfileController: Keyboardable {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        setupNavbar()
        subscribeKeyboardEvents()
        //setPickedImage()
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
        header.backgroundColor = .white
        header.addSubview(self.progressBar)
        self.progressBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(8)
            make.centerY.equalToSuperview()
        }
        
        tableView.tableHeaderView = header
        
        loadData()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavbar() {
        navigationItem.title = "Edit Profile"
        
        let cancelBbi = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelBbi
        
        let updateBbi = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleUpdate))
        navigationItem.rightBarButtonItem = updateBbi
    }
    
    func loadData() {
        UsersApi.usersSelfGET { [unowned self] (user) in
            if let user = user {
                self.showData(user)
            }
        }
        
        if let email = Auth.auth().currentUser?.email {
            self.emailCell.textField.text = email
        }
    }
    
    func showData(_ user: UserDetail) {
        if let name = user.fullname {
            nameCell.textField.text = name
        }
        
        if let bio = user.bio {
            bioCell.textField.text = bio
        }
        
        if let email = user.email {
            emailCell.textField.text = email
        }
        
        if let gender = user.gender {
            genderCell.textField.text = gender
        }
        
        if let urlString = user.avatarURL {
            avartarCell.avatarView.kf.setImage(with: URL(string: urlString))
        }
    }
}


// actions
extension EditProfileController {
    @objc func handleCancel() {
        delegate?.editProfileControllerDidDismiss(self)
    }
    
    @objc func handleUpdate() {
        updateUser()
    }
    
    @objc func importImages() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil )
        
        var selectedImageFromPicker: UIImage?
        
        guard let imageUrl = info[UIImagePickerControllerImageURL] as? URL  else { return }
        uploadPickedImage(imageUrl)
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        guard let selectedImage = selectedImageFromPicker else { return }
        self.avartarCell.setUpImage(selectedImage)
    }
}

// MARK: - Methods
extension EditProfileController {
    func uploadPickedImage(_ url: URL) {
        
        progressBar.isHidden = false
        
        firstly {
            UploadApi.uploadImage(url, progress: updateAvatarProgressUi)
        }.then { url in
            UsersApi.userSelfAvatarPUT(url)
        }.then {
            print("avatar uploaded successfully")
        }.catch { error in
            print(error)
        }.always {
            self.progressBar.isHidden = true
        }
    }
    
    fileprivate func updateAvatarProgressUi(_ doneFraction: Double)  {
        progressBar.progress = Float(doneFraction)
    }
    
     func updateUser() {
        guard let fullname = nameCell.textField.text else { return }
        guard let bio = bioCell.textField.text else { return }
        guard let gender = genderCell.textField.text else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let user = UserUpdate()
        user.fullname = fullname
        user.bio = bio
        user.email = email
        user.gender = gender
        UsersApi.userSelfPUT(user) { (error) in
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.editProfileControllerDidDismiss(self)
            }
        }
    }
}




