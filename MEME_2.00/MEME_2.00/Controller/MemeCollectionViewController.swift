//
//  MemeCollectionViewController.swift
//  MEME_2.00
//
//  Created by Sarah Alasadi on 26/08/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import UIKit
class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.memes ?? []
    }
    
    var screenSize: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFlowLayoutSpacing()
    }
    
   
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func adjustFlowLayoutSpacing() {
        screenSize = UIScreen.main.bounds
        let spacing : CGFloat = 3.0
        let leftRightInset: CGFloat = 3
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: leftRightInset, bottom: 20, right: leftRightInset)
        flowLayout.itemSize = CGSize(width: (screenSize.width - (spacing * 3) - 6) / 3, height: (screenSize.width  - (spacing * 3)) / 3)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "memeCell", for: indexPath as IndexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
      override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMemeController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailMemeController.selectedMeme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailMemeController, animated: true)
    }

    
}
