//
//  MyProfileQuoteEditController.swift
//  Instagram
//
//  Created by alice singh on 13/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
protocol  QuoteEditControllerDelegate: class {
    func quoteEditControllerDidDelete(_ controller: UIViewController)
    func quoteEditControllerDidUpdate(_ controller: UIViewController)
}

class QuoteEditController: UIViewController {
    weak var delegate: QuoteEditControllerDelegate?
    var item: Quote?
    
    init(item: Quote) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        var tableview = UITableView()
        tableview.dataSource = self
        //tableview.delegate = self
        tableview.backgroundColor = .clear
        tableview.keyboardDismissMode = .onDrag
        tableview.separatorStyle = .none
        return tableview
    }()
    
    lazy var  placeCell: CreateItemRowCell = {
        var cell = CreateItemRowCell()
        cell.textField.text = "Delhi"
        return cell
    }()
    
    lazy var quoteCell: CreateItemQuoteCell = {
        var cell = CreateItemQuoteCell()
        return cell
    }()
    
    lazy var buttonCell: CreateItemButtonCell = {
        var cell = CreateItemButtonCell()
        cell.publishButton.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        return cell
    }()
    
    lazy var cells: [UITableViewCell] = [self.placeCell,
                                         self.quoteCell,
                                         self.buttonCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        defaultData()
        setupNavs()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.flatWhite
        self.view.addSubview(tableView)
        
    }
    
    func setupNavs() {
        let deletebbi = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleDelete))
        self.navigationItem.setRightBarButton(deletebbi, animated: true)
        
        let cancelBbi = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.setLeftBarButton(cancelBbi, animated: true)
        
        self.navigationItem.title = "Edit"
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension QuoteEditController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}

extension QuoteEditController {
    func defaultData() {
        self.placeCell.textField.text =  item?.place
        self.quoteCell.textView.text = item?.quote
    }
    
    func doUpdateQuote() {
        guard  let place = self.placeCell.textField.text else { return }
        guard let  quote = self.quoteCell.textView.text else { return }
        guard let id = item?.id else { return }
        
        let model = QuoteUpdate()
        model.place = place
        model.quote = quote
        UsersApi.UserSelfQuotePUT(id, model) { error in
            if let err = error {
                print(err)
                return
            }
            
            // success
            self.dismiss(animated: true)
            self.delegate?.quoteEditControllerDidUpdate(self)
        }
    }
}

//actions
extension QuoteEditController {
    @objc func handlePublish() {
        doUpdateQuote()
    }
    
    @objc func handleDelete() {
        guard let id = item?.id else { return }
        
        UsersApi.userSelfQuoteDelete(id: id, completion: { (error) in
            if let error = error {
                print(error)
                return
            }
            
            // succesfully deleted.
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                self.delegate?.quoteEditControllerDidDelete(self)
            }
        })
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
}

   

