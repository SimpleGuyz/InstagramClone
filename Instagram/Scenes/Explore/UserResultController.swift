//
//  UserResultController.swift
//  Instagram
//
//  Created by Kaushal on 14/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

protocol UserResultControllerDelegate: class {
    func userResult(_ controller: UIViewController, didSelectUser userId: String)
}

class UserResultController: UIViewController {
    weak var delegate: UserResultControllerDelegate?
    
    // var users: [UserDetail] = []
     var quotes: [Quote] = []
    
    enum ResultType {
        case user([UserDetail])
        case quote([Quote])
    }
    
    var resultType: ResultType = .user([]) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        //table.separatorStyle = .none
        table.register(ExploreUserCell.self, forCellReuseIdentifier: "userCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "quoteCell")
        //table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44
        return table
    }()
    
    
    //class should  hide   its  details but expose its functionalites
    //struct should expose ites details but hide   its functionalities
}

extension UserResultController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatWhite
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension UserResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if resultType == .user
        
        switch resultType {
        case .user(let users):
            return users.count
        case .quote(let quotes):
            return quotes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch resultType {
        case .user(let users):
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! ExploreUserCell
            cell.setUpData(users[indexPath.row])
            return cell
        case .quote(let quotes):
            let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath)
            cell.textLabel?.text = quotes[indexPath.row].quote
            cell.textLabel?.font = Fonts.helveticaBold.of(16)
            cell.textLabel?.numberOfLines = 0
             return cell
        }
    }
}

extension UserResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch resultType {
        case .user(let users):
            guard let userId = users[indexPath.row].id else { return }
            delegate?.userResult(self, didSelectUser: userId)
        case .quote:
             print("nthng")
        }
    }
}

extension UserResultController {

}
