//
//  SignInController.swift
//  Instagram
//
//  Created by alice singh on 23/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SignInControllerDelegate: class {
    func signInControllerDoneSignIn(_ controller: UIViewController)
}

class SignInController: UIViewController {
    weak var delegate: SignInControllerDelegate?
    
    lazy var tableView: UITableView = {
        var tableview = UITableView()
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.delegate = self
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.separatorStyle = .none
        tableview.tableFooterView = UIView()
        tableview.keyboardDismissMode = .onDrag
        return tableview
    }()
    
    lazy var headerCell: SignupHeaderCell = {
        var cell = SignupHeaderCell()
        cell.closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return cell
    }()
    
    lazy var whiteCell: UITableViewCell = {
        var cell = UITableViewCell()
        cell.textLabel?.text = "whiteCell"
        cell.textLabel?.font = Fonts.helvetica.of(14)
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var emailCell: SignupFieldCell = {
        var cell = SignupFieldCell()
        cell.textField.placeholder = "Email"
        cell.textField.keyboardType = .emailAddress
        cell.textField.clearButtonMode = .whileEditing
        cell.textField.autocorrectionType = .no
        return cell
    }()
    
    lazy var passwordCell: SignupFieldCell = {
        var cell = SignupFieldCell()
        cell.textField.placeholder = "Password"
        //cell.textField.keyboardType = .numberPad
        cell.textField.isSecureTextEntry = true
        cell.textField.clearButtonMode = .whileEditing
        cell.textField.autocorrectionType = .no
        return cell
    }()
    
    lazy var signInButtonCell: SignupButtonCell = {
        var cell = SignupButtonCell()
        cell.createButton.setTitle("Sign In", for: .normal)
        cell.createButton.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return cell
    }()
    
    lazy var fbButtonCell: SignupFBCell = {
        var cell = SignupFBCell()
        return cell
    }()
    
    lazy var cells: [UITableViewCell] = [
        self.headerCell,
        self.whiteCell,
        self.emailCell,
        self.passwordCell,
        self.signInButtonCell,
        self.fbButtonCell
    ]
}

extension SignInController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        addGuesture()
    }
    
    func setUpViews() {
        self.view.backgroundColor = .white
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints {(make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addGuesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGuesture))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGuesture() {
        self.view.endEditing(true)
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true)
    }
    
    @objc func handleSignInButton() {
        doSignIn()
    }
    
    func doSignIn() {
        guard let emailRaw = emailCell.textField.text else { return }
        let email = emailRaw.trimmingCharacters(in: .whitespaces).lowercased()
        guard  email.count > 0 else { return }
        
        guard let passwordRaw = passwordCell.textField.text else { return }
        let password = passwordRaw.trimmingCharacters(in: .whitespaces)
        guard  password.count > 0 else { return }
        
        // start refresh
        Auth.auth().signIn(withEmail: emailCell.textField.text!, password: passwordCell.textField.text!, completion: { (user, error) in
            // end refresh
            if let error = error {
                print(error)
                return
            }
            
            if user != nil {
                print("success")
                self.dismiss(animated: true)
                self.delegate?.signInControllerDoneSignIn(self)
            }
        })
    }
}
        


extension SignInController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}




