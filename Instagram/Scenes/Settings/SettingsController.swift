//
//  SettingsController.swift
//  Instagram
//
//  Created by alice singh on 26/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import FirebaseAuth
protocol SettingControllerDelegate: class {
    func settingControllerDidSelectEdit(_ controller: UIViewController)
    func settingControllerDidLogout(_ controller: UIViewController)
}

class SettingsController: UIViewController {
    weak var delegate: SettingControllerDelegate?
    
    fileprivate enum Row {
        case edit
        case logout
    }
    
    fileprivate lazy var rows: [Row] = [.edit, .logout]
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstrains()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.flatWhite
        self.navigationItem.title = "Settings"
        self.view.addSubview(tableView)
    }
    
    func setUpConstrains() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = Fonts.helvetica.of(18)
        
        switch rows[indexPath.row] {
        case .edit:
            cell.textLabel?.text = "Edit Profile"
        case .logout:
            cell.textLabel?.text = "Logout"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch rows[indexPath.row] {
        case .edit:
            handleEdit()
        case .logout:
            handleLogout()
        }
    }
}
// actions
extension SettingsController  {
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            delegate?.settingControllerDidLogout(self)
        } catch (let error) {
            print(error)
        }
    }
    
    func handleEdit() {
        delegate?.settingControllerDidSelectEdit(self)
    }
}

