//
//  ViewController.swift
//  Instagram
//
//  Created by alice singh on 16/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

protocol HomeControllerDelegate: class {
    func homeController(_ controller: UIViewController, didSelectUser userId: String)
    func homeControllerDidSelectCreate(_ controller: UIViewController)
}

final class HomeController: UIViewController {
    weak var delegate: HomeControllerDelegate?
    
    //var onDidSelectUser: ((String) -> Void)?
    
    var posts: [FeedItem] = []
    //var detail: [UserDetail] = []
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.register(HomeUserRowCell.self, forCellReuseIdentifier: HomeUserRowCell.reuseId)
        tableView.register(HomeContentRowCell.self, forCellReuseIdentifier: HomeContentRowCell.reuseId)
        tableView.register(HomeActivityRowCell.self, forCellReuseIdentifier: HomeActivityRowCell.reuseId)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func setUpViews() {
        self.view.backgroundColor = .white
        //self.navigationItem.title = "Instagram"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let createBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        createBtn.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        createBtn.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        let creatBbi = UIBarButtonItem(customView: createBtn)
        navigationItem.setRightBarButton(creatBbi, animated: true)
    }
    
    func loadData() {
        FeedApi.feedGET().then { items -> Void in
            self.posts = items
            self.tableView.reloadData()
            return
        }.catch { error in
            print(error)
        }
    }
}

extension HomeController {
    @objc func handleCreate() {
        delegate?.homeControllerDidSelectCreate(self)
    }
}


extension HomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserRowCell.reuseId, for: indexPath) as! HomeUserRowCell
            cell.setData(self.posts[indexPath.section])
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeContentRowCell.reuseId, for: indexPath) as! HomeContentRowCell
            cell.setData(self.posts[indexPath.section])
            return cell
        }
        
        if indexPath.row == 2 {
            return tableView.dequeueReusableCell(withIdentifier: HomeActivityRowCell.reuseId, for: indexPath) as! HomeActivityRowCell
        }
        
        return UITableViewCell()
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let item = posts[indexPath.section]
            if let userId = item.userId {
                //onDidSelectUser?(userId)
                delegate?.homeController(self, didSelectUser: userId)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 200
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
