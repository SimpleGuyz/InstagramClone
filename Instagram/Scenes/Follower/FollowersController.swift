//
//  FollowersController.swift
//  Instagram
//
//  Created by alice singh on 20/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

protocol FollowersControllerDelegate: class {
    func followersControllerdidSelectUser(_ controller: UIViewController,_ id: String)
}

class FollowersController: UIViewController {
    weak var delegate: FollowersControllerDelegate?
    enum Style {
        case follower
        case following
    }
    
    var style: Style
    var userId: String
    var users: [UserDetail] = []
    
    init(userId: String, style: Style = .follower) {
        self.userId = userId
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.backgroundColor = UIColor.flatWhite
        table.dataSource = self
        table.delegate = self
        table.register(FollowersCell.self, forCellReuseIdentifier: "followersCell")
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 80
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        setUpNavBars()
        loadData()
    }
    
    func setUpViews() {
        self.view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpNavBars() {
        if self.style == .follower {
            title = "FOLLOWERS"
        } else {
            title = "FOLLOWINGS"
        }
    }
}

extension FollowersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersCell") as! FollowersCell
        cell.setData(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userid = users[indexPath.row].id else { return }
        delegate?.followersControllerdidSelectUser(self, userid)
    }
}

//Actions
extension FollowersController {

}

// Methods
extension FollowersController {
    func loadData() {
        if style == .follower {
            UsersApi.usersFollowersObserver(userId: self.userId) { (user) in
                if let user = user {
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        } else {
            UsersApi.usersFollowingsObserver(userId: self.userId) { (user) in
                if let user = user {
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
}



