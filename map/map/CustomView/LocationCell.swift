//
//  LocationCell.swift
//  map
//
//  Created by Sarah Alasadi on 15/09/1440 AH.
//  Copyright © 1440 Sarah Alasadi. All rights reserved.
//

import Foundation

import UIKit

class LocationCell: UITableViewCell {
    
    static let identifier = "LocationCell"
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUrl: UILabel!
    
    func configWith(_ info: StudentInformation) {
        labelName.text = info.labelName
        labelUrl.text = info.mediaURL
    }
    
}
