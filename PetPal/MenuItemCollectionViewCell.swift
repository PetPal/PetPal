//
//  MenuItemCollectionViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/2/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    
    var menuItem: MenuItem? {
        didSet {
            menuLabel.text = menuItem?.title
            menuLabel.tintColor = menuItem?.color
            menuImage.image = menuItem?.image
        }
    }
}
