//
//  ProfilePageController.swift
//  Instagram
//
//  Created by alice singh on 22/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

protocol SignupControllerDelegate: class {
    func signUpControllerDoneSignup(_ controller: UIViewController)
}

class SignupController: UIViewController {
    weak var delegate: SignupControllerDelegate?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.clear
        tableview.dataSource = self
        tableview.delegate = self
        tableview.estimatedRowHeight = 100
        tableview.separatorStyle = .none
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView()
        tableview.tableHeaderView = UIView()
        tableview.contentInset = .zero
        tableview.keyboardDismissMode = .onDrag
        return tableview
    }()
    
    lazy var headerCell: SignupHeaderCell = {
        var cell = SignupHeaderCell()
        cell.closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return cell
    }()
    
    lazy var whiteCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.font = Fonts.helveticaBold.of(14)
        cell.textLabel?.text = "Yahooo!"
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var  emailCell: SignupFieldCell = {
        var cell = SignupFieldCell()
        cell.textField.placeholder = "Email"
        cell.textField.keyboardType = .emailAddress
        cell.textField.clearButtonMode = .whileEditing
        cell.textField.autocorrectionType = .no
        return cell
    }()
    
    lazy var  passwordCell: SignupFieldCell = {
        var cell = SignupFieldCell()
        cell.textField.placeholder = "Password"
        cell.textField.isSecureTextEntry = true
        cell.textField.clearButtonMode = .whileEditing
        cell.textField.autocorrectionType = .no
        return cell
    }()
    
    lazy var  fullnameCell: SignupFieldCell = {
        var cell = SignupFieldCell()
        cell.textField.placeholder = "Full name"
        cell.textField.clearButtonMode = .whileEditing
        cell.textField.autocorrectionType = .no
        return cell
    }()
    
    lazy var createButtonCell: SignupButtonCell = {
        var cell = SignupButtonCell()
        cell.createButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return cell
    }()
    
    lazy var fbloginCell: SignupFBCell = {
        var  cell = SignupFBCell()
        return cell
    }()

    lazy var cells: [UITableViewCell] = [
        self.headerCell,
        self.whiteCell,
        self.emailCell,
        self.passwordCell,
        self.fullnameCell,
        self.createButtonCell,
        self.fbloginCell
    ]
}

// MARK :-  Setups
extension SignupController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpContraints()
        setupGesture()
    }
    
    func setUpViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    func setUpContraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true)
    }
    
    @objc func handleSignup() {
        doSignUp()
    }
    
    func doSignUp() {
        guard let emailRaw = emailCell.textField.text else { return }
        let email = emailRaw.trimmingCharacters(in: .whitespaces).lowercased()
        guard  email.count > 0 else { return }
        
        guard let passwordRaw = passwordCell.textField.text else { return }
        let password = passwordRaw.trimmingCharacters(in: .whitespaces)
        guard  password.count > 0 else { return }
        
        guard let fullnameRaw = fullnameCell.textField.text else { return }
        let fullname = fullnameRaw.trimmingCharacters(in: .whitespaces)
        guard  fullname.count > 0 else { return }
        
        // 1
        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self] (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if user != nil {
                print("user authenticated successully")
                // 2.
                self.createUserInDatabase(email: email, fullname: fullname)
            }
        })
    }
    
    func createUserInDatabase(email: String, fullname: String) {
        let body = PostUser()
        body.email = email
        body.fullname = fullname
        UsersApi.userSelfPOST(body) { [unowned self] (error) in
            if let error = error {
                print(error)
                return
            }
            
            // final success
            self.delegate?.signUpControllerDoneSignup(self)
        }
    }
        
}
    
extension SignupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         return cells[indexPath.row]
    }
}
