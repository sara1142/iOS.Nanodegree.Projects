//
//  StudentLocationDetailsViewController.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentLocationDetailsViewController: UIViewController {
    
    
    private let annotationViewIdentifier = "user annotation"
    
    var loggedUser: User!
    
    var parseClient: ParseAPIClientProtocol!
    
    var locationText: String!
    
    var linkText: String!
    
    var placemark: MKPlacemark!
    
    var loggedUserStudentInformation: StudentInformation?
    
    private lazy var studentInformationToPost: StudentInformation = {
        var studentInformation = makeStudentInformation(
            loggedUser: loggedUser,
            locationText: locationText,
            placemark: placemark,
            linkText: linkText
        )
        
        if loggedUserStudentInformation != nil {
            studentInformation.objectID = loggedUserStudentInformation?.objectID
        }
        
        return studentInformation
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    private var selectedViewTapRecognizer: UITapGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(loggedUser != nil)
        precondition(parseClient != nil)
        precondition(locationText != nil)
        precondition(linkText != nil)
        precondition(placemark != nil)
        
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationViewIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let annotation = StudentAnnotation(
            coordinate: placemark.coordinate,
            title: locationText,
            subtitle: linkText,
            studentInformation: studentInformationToPost
        )
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
        mapView.setRegion(
            MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            ),
            animated: true
        )
    }
    
    
    @IBAction func createOrUpdateLocation(_ sender: UIButton) {
        let completionHandler: (StudentInformation?, APIClient.RequestError?) -> Void = { information, error in
            guard error == nil, let information = information else {
                self.displayError(
                    error!,
                    withMessage: """
There was an error while sending the student information to the server, please, try again.
"""
                )
                return
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name.StudentInformationCreated,
                    object: self,
                    userInfo: [ParseAPIClient.UserInfoKeys.CreatedStudentInformation: information]
                )
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        (loggedUserStudentInformation != nil ? parseClient.updateStudentLocation : parseClient.createStudentLocation)(
            studentInformationToPost,
            completionHandler
        )
    }
    
    @objc private func openDefaultBrowser(_ sender: UITapGestureRecognizer?) {
        UIApplication.shared.openDefaultBrowser(accessingAddress: studentInformationToPost.mediaUrl.absoluteString)
    }
    private func makeStudentInformation(
        loggedUser: User,
        locationText: String,
        placemark: MKPlacemark,
        linkText: String
        ) -> StudentInformation {
        guard let urlString = linkText.replacingOccurrences(
            of: " ",
            with: "+"
            ).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                preconditionFailure("Couldn't configure the provided url string.")
        }
        
        return StudentInformation(
            firstName: loggedUser.firstName,
            lastName: loggedUser.lastName,
            latitude: placemark.coordinate.latitude,
            longitude: placemark.coordinate.longitude, mapTextReference: locationText,
            mediaUrl: URL(string: urlString)!,
            key: loggedUser.key
        )
    }
}

extension StudentLocationDetailsViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKPinAnnotationView! = mapView.dequeueReusableAnnotationView(
            withIdentifier: annotationViewIdentifier,
            for: annotation
            ) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
        }
        
        annotationView.displayPriority = .required
        annotationView.pinTintColor = Colors.UserLocationMarkerColor
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDefaultBrowser(_:)))
        view.addGestureRecognizer(selectedViewTapRecognizer!)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.removeGestureRecognizer(selectedViewTapRecognizer!)
    }
}
