//
//  CreateItemController.swift
//  Instagram
//
//  Created by Kaushal on 21/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

protocol CreateItemControllerDelegate: class {
    func createItemControllerDoneSuccessfully(_ controller: UIViewController)
}

class CreateItemController: UIViewController {
    weak var delegate:  CreateItemControllerDelegate?
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
   
    lazy var tableView: UITableView = {
        var tableview = UITableView()
        tableview.backgroundColor = .clear
        tableview.keyboardDismissMode = .onDrag
        tableview.dataSource = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.tableFooterView = UIView()
        return tableview
    }()
    
    lazy var  placeCell: CreateItemRowCell = {
        var cell = CreateItemRowCell()
        cell.textField.text = "Mumbai"
        cell.button.addTarget(self, action: #selector(handleGps), for: .touchUpInside)
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
}

extension CreateItemController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return cells[indexPath.row]
    }
}

// Setups
extension CreateItemController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        setupNavs()
        setupLocationManager()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.flatWhite
        self.navigationItem.title = "Create"
        self.view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupNavs() {
        let closeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        closeBtn.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        let bbi = UIBarButtonItem(customView: closeBtn)
        navigationItem.setLeftBarButton(bbi, animated: true)
    }
    
    func setupLocationManager() {
        
    }
}

// Actions
extension CreateItemController {
    @objc func handlePublish() {
        guard quoteCell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 4 else { return }
        guard let quote = quoteCell.textView.text else { return }
        guard let place = placeCell.textField.text else { return }
        createPost(quote: quote, place: place)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleGps() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}



// Methods
extension CreateItemController {
    fileprivate func createPost(quote: String, place: String) {
        // inputs
        let quoteString = quote.trimmingCharacters(in: .whitespacesAndNewlines)
        let placeString = place.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // create model
        var body = PostItem()
        body.quote = quoteString
        body.place = placeString
        ItemsApi.itemPOST(body) { error in
            if let error = error {
                print(error)
                return
            }
            
            self.afterSuccess()
        }
    }
    
    fileprivate func afterSuccess() {
        // reset fields when all done.
        quoteCell.textView.text = ""
        quoteCell.textView.resignFirstResponder()
        delegate?.createItemControllerDoneSuccessfully(self)
    }
    
    fileprivate func decodePlace(_ location: CLLocation) -> Promise<String> {
        return Promise { pass, fail in
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    fail(error)
                    return
                }
                
                guard let marks = placemarks, marks.count > 0 else { return fail(ApiError.parsing) }
                guard let mark = marks.first else { return fail(ApiError.parsing) }
                
                if let place = mark.locality ?? mark.subLocality ?? mark.name {
                   pass(place)
                } else {
                    fail(ApiError.parsing)
                }
            }
        }
    }
}

extension CreateItemController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            decodePlace(location).then { place in
                self.placeCell.textField.text = place
            }
        }
    }
}
