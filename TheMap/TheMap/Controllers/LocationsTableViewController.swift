//
//  LocationsTableViewController.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

class LocationsTableViewController: UITableViewController {
    
   
    private let locationCellIdentifier = "locationCell"
    
    var parseClient: ParseAPIClientProtocol!
    
    var loggedUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(parseClient != nil)
        precondition(loggedUser != nil)
    }
    
   
    func displayLocations() {
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseClient.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath)
        
        let currentLocation = parseClient.studentLocations[indexPath.row]
        
        if currentLocation.key == loggedUser.key {
            cell.backgroundColor = Colors.UserLocationCellColor
        } else {
            cell.backgroundColor = .white
        }
        
        cell.textLabel?.text = "\(currentLocation.firstName) \(currentLocation.lastName)"
        cell.detailTextLabel?.text = currentLocation.mediaUrl.absoluteString
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentLocation = parseClient.studentLocations[indexPath.row]
        UIApplication.shared.openDefaultBrowser(accessingAddress: currentLocation.mediaUrl.absoluteString)
    }
    

    }

