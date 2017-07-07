//
//  DreamListerTableViewCell.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/18/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

class DreamListerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dreamItemImage: UIImageView!
    @IBOutlet weak var dreamItemTitle: UILabel!
    @IBOutlet weak var dreamItemCost: UILabel!
    @IBOutlet weak var dreamItemDescription: UITextView!

    func configureCell(item: Item) {
        dreamItemTitle.text = item.title
        dreamItemCost.text = "$ \(item.price)"
        dreamItemDescription.text = item.details
        if let img = item.toImage?.image as? UIImage {
            dreamItemImage.image = img
        }
    }
    
}
