//
//  LoginViewController.swift
//  TheMap
//
//  Created by Sarah Alasadi on 28/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    
    var udacityAPIClient: UdacityAPIClientProtocol!
    
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet private weak var usernameTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(udacityAPIClient != nil, "The api client must be injected.")
        
        title = "Login"
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.TabBarController {
            if let navigationController = segue.destination as? UINavigationController,
                let tabController = navigationController.visibleViewController as? LocationsTabBarController {
                tabController.udacityClient = udacityAPIClient
                tabController.parseClient = ParseAPIClient()
                tabController.loggedUser = udacityAPIClient.user
            }
        }
    }
    
    
    
    
    
    
    @IBAction func logIn(_ sender: UIButton?) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                return
        }
        
        enableViews(false)
        
        udacityAPIClient.logIn(withUsername: username, password: password) { account, session, error in
            guard error == nil else {
                self.enableViews(true)
                self.displayError(error!, withMessage: "The username or password provided isn't correct.")
                return
            }
            
            self.udacityAPIClient.getUserInfo(usingUserIdentifier: account!.key) { user, error in
                self.enableViews(true)
                
                guard error == nil else {
                    self.displayError(error!, withMessage: "Couldn't get the user details. Plase, try again later.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifiers.TabBarController, sender: self)
                }
            }
        }
    }
    
    
    private func enableViews(_ isEnabled: Bool) {
        let views = [usernameTextField, passwordTextField, loginButton]
        views.forEach {
            $0?.resignFirstResponder()
            $0?.isEnabled = isEnabled
        }
        
        if isEnabled {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    private func subscribeToKeyboardNotifications() {
        subscribeToNotification(
            named: UIResponder.keyboardWillShowNotification,
            usingSelector: #selector(keyboardWillShow(_:))
        )
        subscribeToNotification(
            named: UIResponder.keyboardWillHideNotification,
            usingSelector: #selector(keyboardWillHide(_:))
        )
        subscribeToNotification(
            named: UIResponder.keyboardDidHideNotification,
            usingSelector: #selector(keyboardDidHide(_:))
        )
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let keyboardY = getKeyboardYOrigin(from: sender) else {
            assertionFailure("Couldn't get the height of the keyboard.")
            return
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let buttonToKeyboardMargin: CGFloat = 10
        let buttonY = view.convert(loginButton.frame, from: loginButton.superview!).origin.y +
            loginButton.frame.size.height + statusBarHeight + buttonToKeyboardMargin
        let bottomVariation = buttonY - keyboardY
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomVariation, right: 0)
        scrollView.scrollRectToVisible(
            CGRect(x: 0, y: contentView.frame.height, width: 1, height: 1),
            animated: true
        )
        scrollView.isScrollEnabled = false
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        scrollView.contentInset = UIEdgeInsets()
    }
    
    @objc private func keyboardDidHide(_ sender: Notification) {
        scrollView.isScrollEnabled = true
    }
    
    
    private func getKeyboardYOrigin(from notification: Notification) -> CGFloat? {
        if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            return keyboardRect.origin.y
        } else {
            return nil
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            logIn(nil)
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension UIViewController {
    
   
    func subscribeToNotification(named name: Notification.Name, usingSelector selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func displayError(_ error: APIClient.RequestError, withMessage message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            var alertMessage: String?
            
            switch error {
            case .connection:
                alertMessage = "There's a problem with your internet connection, please, fix it and try again."
            case .response(_):
                alertMessage = message
            default:
                break
            }
            
            alert.message = alertMessage
            self.present(alert, animated: true)
        }
    }
}
