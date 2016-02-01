//
//  CustomCellView.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 30.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class CustomCellView: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var TextAuthor: UITextView!
    @IBOutlet weak var textDienst: UITextView!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var pressedFav: UIButton!
    @IBAction func pressedFav(sender: AnyObject) {
        print("test")
    }
}
