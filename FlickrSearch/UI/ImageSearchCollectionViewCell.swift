//
//  ImageSearchCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Weichuan Tian on 9/5/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit
import Haneke

class ImageSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(withImageURL imageURL: String?) {
        imageView.image = nil
        if let imageURL = imageURL, url = NSURL(string: imageURL) {
            imageView.hnk_setImageFromURL(url)
        }
    }
}
