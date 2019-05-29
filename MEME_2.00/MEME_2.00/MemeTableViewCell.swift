//
//  MemeTableViewCell.swift
//  MEME_2.00
//
//  Created by Sarah Alasadi on 26/08/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import UIKit
class MemeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var memeText: UILabel!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
     
    }
}
