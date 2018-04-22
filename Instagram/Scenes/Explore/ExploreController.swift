//
//  SearchController.swift
//  Instagram
//
//  Created by Kaushal on 14/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

protocol ExploreControllerDelegate: class {
    func exploreController(_ controller: UIViewController, didSelectUser userId: String)
    func exploreController(_ controller: UIViewController, didSelectQuote quote: Quote)
}

class ExploreController: UIViewController {
    weak var delegate: ExploreControllerDelegate?
    
    //var allUsers: [UserDetail] = []
    var allQuotes: [Quote] = []
    
    lazy var resultController: UserResultController = {
        let controller = UserResultController()
        controller.delegate = self
        return controller
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: self.resultController)
        controller.searchResultsUpdater = self
        //controller.delegate = self
        controller.dimsBackgroundDuringPresentation = true
        controller.searchBar.sizeToFit()
        controller.searchBar.scopeButtonTitles = ["User", "Quote"]
        controller.searchBar.delegate = self
        controller.searchBar.tintColor = UIColor.black
        return controller
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(ExploreAllQuotesCell.self, forCellWithReuseIdentifier: "Cell")
        collection.alwaysBounceVertical = true
        return collection
    }()
}

extension ExploreController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatWhite
        setupViews()
        setupConstraints()
        setupSearchView()
        loadData()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupSearchView() {
        // Make sure the that the search bar is visible within the navigation bar.
        //searchController.searchBar.sizeToFit()
        
        // Include the search controller's search bar within the table's header view.
        //tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension ExploreController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ExploreAllQuotesCell
        cell.backgroundColor = UIColor.white
        cell.setUpData(allQuotes[indexPath.item])
        return cell
    }
}

extension ExploreController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = (self.view.bounds.width - 2)/3
        let h: CGFloat = w
        return CGSize(width: w, height: h)
    }
}

extension ExploreController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let quote = allQuotes[indexPath.item]
        self.delegate?.exploreController(self, didSelectQuote: quote)
        //let detailPage = QuoteDetailController(quote)
       // self.navigationController?.pushViewController(detailPage, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        processResult(for: searchController.searchBar)
    }
    
    
    fileprivate func processResult(for searchBar: UISearchBar) {
        let searchText = searchBar.text
        if self.searchController.searchBar.selectedScopeButtonIndex == 0 { // users
            if let name = searchText {
                SearchApi.searchUserBy(fullname: name).then { results in
                    self.resultController.resultType = .user(results)
                }.catch(execute: { (error) in
                    print(error)
                })
            }
        } else { // quotes
            //self.resultController.resultType = .quote(self.allQuotes)
        }
    }
    
}

extension ExploreController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        processResult(for: searchBar)
    }
}

extension ExploreController: UserResultControllerDelegate {
    func userResult(_ controller: UIViewController, didSelectUser userId: String) {
        self.delegate?.exploreController(self, didSelectUser: userId)
    }
}

// methods
extension  ExploreController {
    func loadData() {
        loadUsers()
        loadQuotes()
    }
    
    func loadUsers() {
//        UsersApi.allUserGET { (items) in
//            if let items = items {
//                self.allUsers = items
//                //self.tableView.reloadData()
//            }
//        }
    }
    
    func loadQuotes() {
        ItemsApi.itemsAllQuotes().then { quotes -> Void  in
            self.allQuotes = quotes
            self.collectionView.reloadData()
        }
    }
}

