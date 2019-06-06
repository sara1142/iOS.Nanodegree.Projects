//
//  LocationsTabBarController.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationsTabBarController: UITabBarController {
    
    
    private let addNewSegueIdentifier = "show controller to add a new segue"
    
    var udacityClient: UdacityAPIClientProtocol!
    
    var parseClient: ParseAPIClientProtocol!
    
    var loggedUser: User!
    
    var loggedUserStudentInformation: StudentInformation?
    
    var locationManager: CLLocationManager!
    
    
    deinit {
        unsubscribeFromAllNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(udacityClient != nil)
        precondition(parseClient != nil)
        precondition(loggedUser != nil)
        
        locationManager = CLLocationManager()
        
        guard let mapsViewController = viewControllers!.first as? LocationsMapViewController,
            let tableViewController = viewControllers!.last as? LocationsTableViewController else {
                preconditionFailure("Couldn't correclty get the child view controllers.")
        }
        
        mapsViewController.loggedUser = loggedUser
        mapsViewController.parseClient = parseClient
        tableViewController.loggedUser = loggedUser
        tableViewController.parseClient = parseClient
        
        delegate = self
        
        subscribeToNotification(
            named: Notification.Name.StudentInformationCreated,
            usingSelector: #selector(displayCreatedLocation(usingNotification:))
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadLocations()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addNewSegueIdentifier {
            if let addLocationController = segue.destination as? AddLocationViewController {
                addLocationController.loggedUser = loggedUser
                addLocationController.parseClient = parseClient
                addLocationController.loggedUserStudentInformation = loggedUserStudentInformation
                
                if let mapController = viewControllers?.first as? LocationsMapViewController {
                    addLocationController.userLocation = mapController.mapView.userLocation
                }
            }
        }
    }
    
    
    @IBAction func loadLocations(_ sender: UIBarButtonItem? = nil) {
        sender?.isEnabled = false
        
        
        func showFetchedLocationsOnMainThread(_ locations: [StudentInformation]) {
            DispatchQueue.main.async {
                sender?.isEnabled = true
                self.displayStudentLocations(locations)
            }
        }
        
        parseClient.fetchStudentLocations(withLimit: 100, skippingPages: 0) { locations, error in
            let errorMessage = """
There was an error while downloading the students' locations, please, contact the app developer.
"""
            
            guard let locations = locations, error == nil else {
                self.displayError(error ?? .malformedJson, withMessage: errorMessage)
                DispatchQueue.main.async {
                    sender?.isEnabled = true
                }
                return
            }
            
            if self.loggedUserStudentInformation == nil {
                if let loggedUserInformation = locations.filter({ $0.key == self.loggedUser.key }).first {
                    self.loggedUserStudentInformation = loggedUserInformation
                    showFetchedLocationsOnMainThread(locations)
                } else {
                    _ = self.parseClient.fetchStudentLocation(byUsingUniqueKey: self.loggedUser.key) { information, _ in
                        if let information = information {
                            self.loggedUserStudentInformation = information
                            self.parseClient.studentLocations.append(information)
                            self.parseClient.sortLocations()
                        }
                        
                        showFetchedLocationsOnMainThread(self.parseClient.studentLocations)
                    }
                }
            } else {
                showFetchedLocationsOnMainThread(locations)
            }
        }
    }
    
    @IBAction func logUserOut(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        udacityClient.logOut { isSuccessful, error in
            guard isSuccessful, error == nil else {
                self.displayError(error!, withMessage: "There was an error while logging out. Please, try again later.")
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                sender.isEnabled = true
            }
        }
    }
    
   
    @objc private func displayCreatedLocation(usingNotification notification: NSNotification) {
        guard let createdInformation =
            notification.userInfo?[ParseAPIClient.UserInfoKeys.CreatedStudentInformation] as? StudentInformation else {
                preconditionFailure("Coulnd't get the created student information from the notification.")
        }
        
        loggedUserStudentInformation = createdInformation
        
        parseClient.studentLocations.removeAll {
            $0.key == createdInformation.key && $0.objectID == createdInformation.objectID
        }
        parseClient.studentLocations.append(createdInformation)
        parseClient.sortLocations()
        
        displayStudentLocations(parseClient.studentLocations)
    }
    
    
    private func displayStudentLocations(_ locations: [StudentInformation]) {
        guard let mapController = viewControllers?.first as? LocationsMapViewController,
            let tableViewController = viewControllers?.last as? LocationsTableViewController else {
                assertionFailure("Couldn't get the controllers.")
                return
        }
        
        tableViewController.displayLocations()
        mapController.displayLocations()
    }
}

extension LocationsTabBarController: UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        title = viewController.title
    }
}
