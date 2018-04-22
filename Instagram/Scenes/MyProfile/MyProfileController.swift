//
//  MyProfileController.swift
//  Instagram
//
//  Created by Kaushal on 24/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol MyProfileControllerDelegte: class {
    func myProfileControllerDidClickFollowersButton(_ controller: UIViewController)
    func myprofileControllerDidClickFollowingButton(_ controller: UIViewController)
    func myProfileController(_ controller: UIViewController, didSelectAvatar url: URL)
    func myProfileControllerDidSelectSetting(_ controller: UIViewController)
}

class MyProfileController: UIViewController {
    weak var delegate: MyProfileControllerDelegte?
    
    var userDetail: UserDetail?
    var items: [Quote] = []
    var followers: Int = 0
    var followings: Int = 0
   
    lazy var fullnameLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.helveticaBold.of(24)
        label.textColor = UIColor.flatGrayDark
        label.textAlignment = .center
        return label
    }()
    
    lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        //let w = (UIScreen.main.bounds.width - 8) / 3
        //layout.estimatedItemSize = CGSize(width: w, height: w)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.register(UserQuoteCell.self, forCellWithReuseIdentifier: "itemCell")
        collection.register(MyProfileHeaderCell.self, forCellWithReuseIdentifier: "headerCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collection.refreshControl = refresh
        return collection
    }()
}

// setups
extension MyProfileController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpContraints()
        loadData()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        // title
        navigationItem.titleView = fullnameLabel
        
        // right
        let settingBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
        settingBtn.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
        settingBtn.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        let settingBbi = UIBarButtonItem(customView: settingBtn)
        navigationItem.setRightBarButton(settingBbi, animated: true)
    }
    
    func setUpContraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// table datasource
extension MyProfileController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  section == 0 ? 1 : items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! MyProfileHeaderCell
            cell.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAvatar)))
            cell.followersButton.addTarget(self, action: #selector(handleFollowers), for: .touchUpInside)
            cell.followingButton.addTarget(self, action: #selector(handleFollowing), for: .touchUpInside)
            cell.followButton.isHidden = true
            cell.setData(userDetail)
            cell.setStats(followers: self.followers, followings: self.followings)
            return cell
        }
        
        // other cases
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! UserQuoteCell
        cell.setData(items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let item = items[indexPath.item]
            askOptions(for: item)
        }
    }
    
    fileprivate func askOptions(for item: Quote) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.showEditPage(for: item)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(edit)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    fileprivate func showEditPage(for item: Quote) {
        // on edit
        let editPage = QuoteEditController(item: item)
        editPage.delegate = self
        let nav = UINavigationController(rootViewController: editPage)
        self.present(nav, animated: true, completion: nil)
    }
}

// table delegates
extension MyProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return  CGSize(width: UIScreen.main.bounds.width, height: 300) //UICollectionViewFlowLayoutAutomaticSize
        }
        
        let w = (UIScreen.main.bounds.width - 8) / 3
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 2 // irrerlevent as this section will have only one cell.
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        }
        
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
}


// actions
extension MyProfileController {
    /*
    @objc func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            delegate?.myProfileControllerDidLogout(self)
        } catch (let error) {
            print(error)
        }
    }
    
    @objc func handleEdit() {
        self.dismiss(animated: true, completion: nil)
        delegate?.myProfileControllerDidSelectEdit(self)
    }
 */
    @objc func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        self.items = []
        loadData()
    }
    
    @objc func handleFollowers() {
        delegate?.myProfileControllerDidClickFollowersButton(self)
    }
    
    @objc func handleFollowing() {
        delegate?.myprofileControllerDidClickFollowingButton(self)
    }
    
    @objc func handleAvatar() {
        guard let urlString = userDetail?.avatarURL, let url = URL(string: urlString) else { return }
        self.delegate?.myProfileController(self, didSelectAvatar: url)
    }
    
    @objc func handleSettings() {
        self.delegate?.myProfileControllerDidSelectSetting(self)
    }
}

// methods
extension MyProfileController {
    func loadData() {
        loadSelfDetail()
        loadQuotes()
        loadStats()
    }
    
    func loadSelfDetail() {
        UsersApi.userSelfObserve { [unowned self] (user) in
            if let user = user {
                self.showData(user)
            }
        }
    }
    
    func loadQuotes() {
        UsersApi.userSelfQuotesObserver { (quote) in
            if let quote = quote {
                self.items.append(quote)
                self.collectionView.reloadData()
//                self.collectionView.performBatchUpdates({
//                    let newIndex = self.items.count - 1
//                    self.collectionView.insertItems(at: [IndexPath(item: newIndex, section: 1)])
//                }, completion: nil)
            }
        }
    }
    
    func loadStats() {
        UsersApi.userSelfFollowersCountGET { (count) in
            self.followers = count ?? 0
            self.collectionView.reloadData()
        }
        
        UsersApi.userSelfFollowingsCountGET { (count) in
            self.followings = count ?? 0
            self.collectionView.reloadData()
        }
    }
    
    func showData(_ detail: UserDetail) {
        userDetail = detail
        collectionView.reloadData()
        
        fullnameLabel.text = detail.fullname
        fullnameLabel.sizeToFit()
        
//        fullnameCell.label.text = detail.fullname
//        bioCell.label.text = detail.bio
//        genderCell.label.text = detail.gender
//        emailCell.label.text = detail.email
//        if let urlString = detail.avatarURL {
//            let url = URL(string: urlString)
//            avatarCell.avatarView.kf.setImage(with: url)
//        }
//        tableView.reloadData()
    }
}

extension MyProfileController: QuoteEditControllerDelegate {
    func quoteEditControllerDidDelete(_ controller: UIViewController) {
        loadQuotes()
    }
    
    func quoteEditControllerDidUpdate(_ controller: UIViewController) {
        loadData()
    }
}


