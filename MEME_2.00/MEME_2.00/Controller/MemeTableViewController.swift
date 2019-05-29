//
//  MemeTableViewController.swift
//  MEME_2.00
//
//  Created by Sarah Alasadi on 26/08/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//
import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    
      private var UTableView: UITableView!
    private var didSetupConstraints = false

    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.memes ?? []
        
    }
    
    
  

    override func viewWillAppear(_ animated: Bool)
    {
       super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath as IndexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        cell.memeText.text = meme.topText + " " + meme.bottomText
        cell.memeImage.image = meme.memeImage
        
        
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == UITableViewCell.EditingStyle.delete) {
                
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.selectedMeme = memes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }



}
