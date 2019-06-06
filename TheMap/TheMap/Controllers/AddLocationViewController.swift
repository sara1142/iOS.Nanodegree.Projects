//
//  AddLocationViewController.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
   
    private let segueIdentifier = "show annotation on the map"
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var geocodeActivityIndicator: UIActivityIndicatorView!
    
    var loggedUser: User!
    
    var parseClient: ParseAPIClientProtocol!
    
    var userLocation: MKUserLocation?
    
    private var searchedPlacemark: MKPlacemark?
    
    var loggedUserStudentInformation: StudentInformation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(loggedUser != nil)
        precondition(parseClient != nil)
        
        if let userInformation = loggedUserStudentInformation {
            locationTextField.text = userInformation.mapTextReference
            linkTextField.text = userInformation.mediaUrl.absoluteString
        }
        
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return searchedPlacemark != nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationText = locationTextField.text!
        let linkText = linkTextField.text!
        
        if let detailsController = segue.destination as? StudentLocationDetailsViewController {
            detailsController.loggedUser = loggedUser
            detailsController.parseClient = parseClient
            detailsController.locationText = locationText
            detailsController.linkText = linkText
            detailsController.placemark = searchedPlacemark
            detailsController.loggedUserStudentInformation = loggedUserStudentInformation
        }
    }
    
    
    @IBAction func findLocationOnMap(_ sender: UIButton?) {
        guard let locationText = locationTextField.text, !locationText.isEmpty,
            let linkText = linkTextField.text, !linkText.isEmpty else {
                return
        }
        
        sender?.isEnabled = false
        
        let mapSearchRequest = MKLocalSearch.Request()
        mapSearchRequest.naturalLanguageQuery = locationText
        if let userLocation = userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            )
            mapSearchRequest.region = userRegion
        }
        
        findLocationButton.isEnabled = false
        geocodeActivityIndicator.startAnimating()
        [locationTextField, linkTextField].forEach { $0?.resignFirstResponder() }
        
        let localSearch = MKLocalSearch(request: mapSearchRequest)
        localSearch.start { response, error in
            self.geocodeActivityIndicator.stopAnimating()
            self.findLocationButton.isEnabled = true
            
            guard error == nil, let response = response, !response.mapItems.isEmpty else {
                self.displayError(
                    .lackingData,
                    withMessage: "Couldn't find the entered location, please, try a more specific term."
                )
                return
            }
            
            self.searchedPlacemark = response.mapItems.first!.placemark
            self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
        }
    }
}

extension AddLocationViewController {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            linkTextField.becomeFirstResponder()
        } else if textField == linkTextField {
            findLocationOnMap(nil)
            if (textField.text ?? "").isEmpty {
                return false
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}
