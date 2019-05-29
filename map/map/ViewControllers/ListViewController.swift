//
//  ListViewController.swift
//  map
//
//  Created by Sarah Alasadi on 15/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, LocationSelectionDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: DataProvider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        dataProvider.delegate = self
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        reloadCompleted()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func reloadStarted () {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    
    func didSelectLocation(info: StudentInformation) {
        openWithSafari(info.mediaURL)
    }
    
}
