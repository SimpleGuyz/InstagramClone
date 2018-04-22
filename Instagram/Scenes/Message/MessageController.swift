//
//  MessageController.swift
//  Instagram
//
//  Created by Kaushal on 05/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit
import FirebaseAuth

final class MessageController: UIViewController, Keyboardable {
    var messages: [MessageViewModel] = []
    var conversationId: String
    
    // UI
    var botttomConstraint: Constraint?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.flatWhite
        table.dataSource = self
        //table.delegate = self
        //table.separatorStyle = .none
        table.register(MessageRightCell.self, forCellReuseIdentifier: "RightCell")
        table.register(MessageLeftCell.self, forCellReuseIdentifier: "LeftCell")
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 150
        table.keyboardDismissMode = .onDrag
        return table
    }()
    
    lazy var inputBar: MessageInputBar = {
        let inputBar = MessageInputBar()
        inputBar.delegate = self
        return inputBar
    }()
    
    
    init(conversationid: String) {
        self.conversationId = conversationid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNav()
        subscribeKeyboardEvents()
        
        loadMessages().then {
           self.listenToAnyNewMessage()
        }
        
        loadOpponentDetail()
    }
    
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [tableView, inputBar])
        stack.axis = .vertical
        self.view.addSubview(stack)
        
        stack.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            self.botttomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
        }
        
        inputBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
        }
    }
    
    fileprivate func setupNav() {
        navigationItem.title = "Message"
        
        let rightBbi = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleRightBbi))
        navigationItem.setRightBarButton(rightBbi, animated: true)
    }
}

extension MessageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.isSelf == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightCell", for: indexPath) as! MessageRightCell
            cell.setData(message)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell", for: indexPath) as! MessageLeftCell
        cell.setData(message)
        return cell
        
    }
}

// actions / Methods
extension MessageController {
    @objc func handleRightBbi() {
        /*
        let new = [
            Message(id: "1001",
                    content: "Hi there this is kaushal, how do you do? i hope good. m good anda msdkjs sd kjhk adhk you",
                    isSelf: true),
            Message(id: "1002",
                    content: "Hello, m good and you. ",
                    isSelf: true),
            Message(id: "1003",
                    content: "Hi there o you do? i hope good.",
                    isSelf: false),
            Message(id: "1004",
                    content: "Hello, m good anda msdkjs sd kjhk adhk you.",
                    isSelf: false),
        ]
        
        self.messages.append(contentsOf: new)
        self.tableView.reloadData()
        */
    }
    
    fileprivate func sendMessage(_ text: String) {
        MessageApi.sendMessage(message: text, conversationId: conversationId)
            .then(execute: createViewModel)
            .then { new -> Void in
                //self.messages.append(new)
                //self.tableView.reloadData()
                //self.scrollLastRowToVisible()
            }
    }
    
    fileprivate func createViewModel(_ model: Message) -> Promise<MessageViewModel> {
        return Promise(value: createViewModel(model))
    }
    
    fileprivate func createViewModel(_ model: Message) -> MessageViewModel {
        let selfUserId = Auth.auth().currentUser?.uid ?? "FakeId"
        let viMo = MessageViewModel(id: model.id ?? "",
                                    content: model.content ?? "-",
                                    usersName: model.userId ?? "userId",
                                    time: "12:00",
                                    isSelf: model.userId == selfUserId)
        return viMo
    }
    
    
    fileprivate func scrollLastRowToVisible() {
        guard self.messages.count > 0 else { return }
        self.tableView.performBatchUpdates(nil) { (success) in
            let lastIndexPath = IndexPath(item: (self.messages.count - 1), section: 0)
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    func loadOpponentDetail() {
        MessageApi.opponentDetail(for: self.conversationId).then { detail in
            self.navigationItem.title = detail.fullname
        }
    }
    
    func loadMessages() -> Promise<Void> {
        return  MessageApi.readAllMessages(for: self.conversationId)
            .then { all -> Promise<Void> in
                let vms: [MessageViewModel] = all.map { self.createViewModel($0) }
                self.messages.append(contentsOf: vms)
                self.tableView.reloadData()
                return Promise(value: ())
            }
    }
    
    func listenToAnyNewMessage() {
        MessageApi.observeNewMessage(self.conversationId) { (new) in
            if let new = new {
                let newVM: MessageViewModel = self.createViewModel(new)
                self.messages.append(newVM)
                self.tableView.reloadData()
            }
        }
    }
}

extension MessageController {
    func keyboardWillHide(duration: Double, curveAnimation: UInt) {
        self.botttomConstraint?.update(inset: 0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIViewAnimationOptions(rawValue: curveAnimation),
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillShow(height: CGFloat, duration: Double, curveAnimation: UInt) {
        self.botttomConstraint?.update(inset: height)
        

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIViewAnimationOptions(rawValue: curveAnimation),
                       animations: {
                            self.view.layoutIfNeeded()
                       }, completion: { success in
                            self.scrollLastRowToVisible()
                        })
    }
}

extension MessageController: MessageInputBarDelegate {
    func messageInputBar(bar: MessageInputBar, didSendMessage message: String) {
        sendMessage(message)
    }
}

extension MessageController {
    
}
