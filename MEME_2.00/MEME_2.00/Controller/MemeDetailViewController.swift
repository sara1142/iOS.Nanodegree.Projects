//
//  MemeDetailViewController.swift
//  MEME_2.00
//
//  Created by Sarah Alasadi on 26/08/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeImage: UIImageView!
    
    
    
    var selectedMeme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = selectedMeme.memeImage
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func editMeme(_ sender: Any) {
        
        let editController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editController.meme = selectedMeme
        editController.editingMeme = true
        navigationController?.present(editController, animated: true, completion: nil)
    }
    
    
}
