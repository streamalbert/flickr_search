//
//  ImageDetailViewController.swift
//  FlickrSearch
//
//  Created by Weichuan Tian on 9/5/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit
import Haneke

class ImageDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    private let photoItem: PhotoItemDataModel
    private var hasPopulatedData = false

    // MARK: - Initializer
    init(withPhotoItem item: PhotoItemDataModel) {
        self.photoItem = item
        super.init(nibName: String(ImageDetailViewController), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 2.0;
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if hasPopulatedData {
            return
        }
        hasPopulatedData = true

        titleLabel.text = photoItem.title
        if let imageURL = photoItem.imageURLHighRes, url = NSURL(string: imageURL) {

            Shared.imageCache.fetch(URL: url).onSuccess({ image in
                let imageWidth = CGRectGetWidth(self.view.bounds)
                let imageHeight = imageWidth * image.size.height / image.size.width
                self.imageViewWidthConstraint.constant = imageWidth
                self.imageViewHeightConstraint.constant = imageHeight
                self.scrollViewHeightConstraint.constant = imageHeight
                self.scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
                self.imageView.image = image
            })
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageDetailViewController: UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
}
