//
//  ConversationsController.swift
//  Instagram
//
//  Created by Kaushal on 08/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

protocol ConversationControllerDelegate: class {
    func conversationsController(_ controller: UIViewController, didSelectConversation conversationId: String)
}

class ConversationsController: UIViewController {
    weak var delegate: ConversationControllerDelegate?
    
    var conversations: [ConversationShort] = []

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        //table.separatorStyle = .none
        table.register(ConversationsCell.self, forCellReuseIdentifier: ConversationsCell.reuseId)
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 150
        return table
    }()
}

extension ConversationsController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavs()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.flatWhite
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavs() {
        navigationItem.title = "Recent Messages"
    }
}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: ConversationsCell.reuseId, for: indexPath) as! ConversationsCell
        let detail = self.conversations[indexPath.row]
        cell.setUpData(detail)
        return cell
    }
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let converId = conversations[indexPath.row].id else { return }
        delegate?.conversationsController(self, didSelectConversation: converId)
    }
}


extension ConversationsController {
    func loadData() {
        MessageApi.readConversationShort().then { conversations -> Void in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
}
