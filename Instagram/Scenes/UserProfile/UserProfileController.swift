//
//  UserProfileController.swift
//  Instagram
//
//  Created by Kaushal on 07/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol UserProfileControllerDelegate: class {
    func userProfileController(_ controller: UIViewController, didSelectFollowers userId: String)
    func userProfileController(_ controller: UIViewController, didSelectFollowings userId: String)
    func userProfileController(_ controller: UIViewController, didSelectAvatar url: URL)
    func userProfileController(_ controller: UIViewController, didSelectConversation conversationId: String)
}

class UserProfileController: UIViewController {
    weak var delegate: UserProfileControllerDelegate?
    
    var userId: String
    var detail: UserDetail?
    var amIFollowing: Bool = false
    var followers = 0
    var followings = 0
    
    var items: [Quote] = []
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return  layout
    }()
    
    lazy var collectionView: UICollectionView = {
        var collectionview = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionview.backgroundColor = .clear
        collectionview.dataSource = self
        collectionview.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionview.register(MyProfileHeaderCell.self, forCellWithReuseIdentifier: "headerCell")
        collectionview.register(UserQuoteCell.self, forCellWithReuseIdentifier: "quoteCell")
        collectionview.refreshControl = refreshControl
        return collectionview
    }()
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserProfileController:  UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! MyProfileHeaderCell
            
            if self.userId == Auth.auth().currentUser?.uid {
                cell.followButton.isHidden = true
            } else {
                cell.followButton.isHidden = false
            }
            
            cell.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAvatarTap)))
            cell.followButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
            cell.followersButton.addTarget(self, action: #selector(handleFollowersClick), for: .touchUpInside)
            cell.followingButton.addTarget(self, action: #selector(handleFollowingClick), for: .touchUpInside)
            cell.setData(detail, amIFollowing: self.amIFollowing)
            cell.setStats(followers: self.followers, followings: self.followings)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCell", for: indexPath) as! UserQuoteCell
        cell.setData(items[indexPath.item])
        return cell
    }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 300)
        }
        
        let w = (UIScreen.main.bounds.width - 8) / 3
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
         return 2
    }
}

// setups
extension UserProfileController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpContraints()
        setupNav()
        loadData()
    }
    
    @objc func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        loadData()
    }
    
    func setupViews() {
        //self.navigationItem.title = detail?.fullname
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
    }
    
    func setUpContraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNav() {
        let chatBBi = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleChat))
        navigationItem.setRightBarButton(chatBBi, animated: true)
    }
}

// Actions
extension UserProfileController {
    @objc func handleFollow() {
        if amIFollowing == true {
            UsersApi.userFollowDELETE(userId: self.userId)
        } else {
            UsersApi.userFollowPOST(userId: self.userId)
        }
        
        amIFollowing = !amIFollowing
        collectionView.reloadData()
    }
    
    @objc func handleFollowersClick() {
        delegate?.userProfileController(self, didSelectFollowers: self.userId)
    }
    
    @objc func handleFollowingClick() {
        delegate?.userProfileController(self, didSelectFollowings: self.userId)
    }
    
    @objc func handleAvatarTap() {
        guard let urlString = self.detail?.avatarURL, let url = URL(string: urlString) else { return }
        delegate?.userProfileController(self, didSelectAvatar: url)
    }
    
    @objc func handleChat() {
        MessageApi.fetchConversationId(userId: self.userId).then { (conversationId) in
            self.delegate?.userProfileController(self, didSelectConversation: conversationId)
        }
    }
}

// methods
extension UserProfileController {
   func loadData() {
        // 1.
        loadDetail()
    
        // 2.
        loadQuotes()
    
        // 3.
        loadStats()
    }
    
    fileprivate func loadDetail() {
        UsersApi.usersUserIdGET(userId: userId).then { detail -> Void in
            self.detail = detail
            self.showData(detail)
        }.catch { error in
            print(error)
        }
        
    
//        UsersApi.usersUserIdGET(userId: userId) { [unowned self] (detail) in
//            if let detail = detail {
//                self.detail = detail
//                self.showData(detail)
//            }
//        }
    }
    
    fileprivate func showData(_ detail: UserDetail) {
        guard let fullname = detail.fullname else { return }
        navigationItem.title = fullname
        collectionView.reloadData()
    }
    
    fileprivate func loadQuotes() {
        UsersApi.userQuotesObserver(userid: userId) { (quote) in
            if let quote = quote {
                self.items.append(quote)
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func loadStats() {
        UsersApi.userSelfIsFollowing(userId: self.userId) { (amIFollowing) in
            self.amIFollowing = amIFollowing ?? false
            self.collectionView.reloadData()
        }
        
//        UsersApi.userFollowersCountGET(userId: self.userId) { (count) in
//            self.followers = count ?? 0
//            self.collectionView.reloadData()
//        }
        
        UsersApi.userFollowersCountGET(userId: self.userId).then { count -> Void  in
            self.followers = count
            self.collectionView.reloadData()
            }.catch { (error) in
                print(error)
        }
        
//        UsersApi.userFollowingsCountGET(userId: self.userId) { (count) in
//            self.followings = count ?? 0
//            self.collectionView.reloadData()
//        }
        
        UsersApi.userFollowingsCountGET(userId: self.userId).then { count -> Void  in
            self.followings = count
            self.collectionView.reloadData()
            }.catch { (error) in
                print(error)
        }
    }
}

