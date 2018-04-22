//
//  QuoteDetailController.swift
//  Instagram
//
//  Created by alice singh on 04/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

class QuoteDetailController: UIViewController {
    var quote: Quote
    var detail: UserDetail?
    
    init(_ quote: Quote) {
        self.quote = quote
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        table.register(QuoteDetailUserNameCell.self, forCellReuseIdentifier: QuoteDetailUserNameCell.reuseId)
        table.register(QuoteDetailQuoteCell.self, forCellReuseIdentifier: QuoteDetailQuoteCell.reuseId)
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    lazy var nameCell: QuoteDetailUserNameCell = {
        var cell = QuoteDetailUserNameCell()
        return cell
    }()
    
    lazy var quoteCell: QuoteDetailQuoteCell = {
        var cell = QuoteDetailQuoteCell()
        return cell
    }()
    
    lazy var cells: [UITableViewCell] = [self.quoteCell,
                                         self.nameCell,]
}

extension QuoteDetailController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        loadData()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.flatWhite
        self.view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension QuoteDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}

extension QuoteDetailController {
    func loadData() {
        // 1. use injected quote
        quoteCell.setUpData(self.quote)
        tableView.reloadData()
        
        //2. request user detail
        guard let userId = quote.userId else { return }
        UsersApi.usersUserIdGET(userId: userId)
            .then(execute: handleUserDetail)
            .catch(execute: showError)
    }
    
    fileprivate func handleUserDetail(_ detail: UserDetail?) {
        guard let detail = detail else { return }
        self.detail = detail
        self.nameCell.setUpData(detail)
        self.tableView.reloadData()
    }
    
    fileprivate func showError(_ error: Error) {
        // show error
    }
}
