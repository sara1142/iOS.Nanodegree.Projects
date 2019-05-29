//
//  MemeEditorViewController.swift
//  MEME1.0
//
//  Created by Sarah Alasadi on 11/08/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import UIKit

import MobileCoreServices


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
       var editingMeme = false
     var meme: Meme!
    struct Meme {
        let topText: String!
        let bottomText: String!
        let originalImage: UIImage!
        let memedImage: UIImage!
    }
    
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSAttributedString.Key.strokeWidth : -4.0
    ] as! [NSAttributedString.Key : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylizeTextField(textFiled: topTextField, with: "TOP")
        stylizeTextField(textFiled: bottomTextField, with: "BOTTOM")
        
    }
    
    func stylizeTextField(textFiled: UITextField, with defaultText: String){

        textFiled.defaultTextAttributes = memeTextAttributes
        textFiled.textAlignment = NSTextAlignment.center
        textFiled.text = defaultText
        textFiled.isHidden = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        topTextField.delegate = self
        bottomTextField.delegate = self

         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        
    }
    
    

    func pickAnImageFromSource(source: UIImagePickerController.SourceType){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    

    @IBAction func cameraButtonAction(_ sender: Any) {
        pickAnImageFromSource(source: .camera)
    }
    
    
    
    @IBAction func photoLibraryAction(_ sender: Any) {
        
        

        
        pickAnImageFromSource(source: .photoLibrary)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
 
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
            }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text?.uppercased() == "TOP" || textField.text?.uppercased() == "BOTTOM") {
            textField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification){

//        view.frame.origin.y = -getKeyboardHeight(notification)
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y =  getKeyboardHeight(notification) * (-1)
            
            
        }
        
    }
    
   
    
    func subscribeToKeyboardNotifications() {


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

    }
    
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
          
            view.frame.origin.y = 0
        }
        
    
    }
    func unsubscribeToKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
       
        navigationBar.isHidden = false
        toolBar.isHidden = false
        return memedImage
    }
    func save() {
        
        let memedImage = generateMemedImage()
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
                        originalImage: imageView.image, memedImage:memedImage)
        

}
 
    @IBAction func shareButtonAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems:
            [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity,
            success, items, error in
            
            
            if success{
                 self.save()
            }
            self.dismiss(animated: true, completion: nil)
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        self.imageView.image = nil
    }
}
    

