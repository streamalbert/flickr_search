//
//  ImageSearchViewController.swift
//  FlickrSearch
//
//  Created by Weichuan Tian on 9/5/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

private let NumberOfColumns = 3
private let ImageSearchCollectionViewCellReuseIdentifier = "ImageSearchCollectionViewCellReuseIdentifier"

class ImageSearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: - Properties
    private var photoItems: [PhotoItemDataModel] = []
    private var currentPage = 1
    private var currentSearchTerm = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Search Flickr"

        collectionView.backgroundColor = UIColor.whiteColor()
        var contentInset = collectionView.contentInset
        contentInset.top = CGRectGetMaxY(searchBar.frame)
        collectionView.contentInset = contentInset

        collectionView.registerNib(UINib(nibName: String(ImageSearchCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCellReuseIdentifier)

        configInfiniteScrolling()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
    }

}

// MARK: - Private Extension
private extension ImageSearchViewController {
    
    func configInfiniteScrolling() {

        collectionView.addInfiniteScrollWithHandler { [weak self] (collectionView) -> Void in

            guard let strongSelf = self else {
                return
            }

            strongSelf.currentPage += 1
            DataServiceManager.sharedManager.fetchPhotos(withSearchTerm: strongSelf.currentSearchTerm, page: strongSelf.currentPage, photosPerPage: NumberOfColumns * 10) { (success, photoItems, error) in
                if success {
                    var currentLastIdx = strongSelf.photoItems.count
                    var newIndexPaths: [NSIndexPath] = []
                    photoItems.forEach({
                        newIndexPaths.append(NSIndexPath(forItem: currentLastIdx, inSection: 0))
                        strongSelf.photoItems.append($0)
                        currentLastIdx += 1
                    })

                    collectionView.performBatchUpdates({ () -> Void in
                        // add new items into collection
                        collectionView.insertItemsAtIndexPaths(newIndexPaths)
                    }, completion: { (finished) -> Void in
                        // finish infinite scroll animations
                        collectionView.finishInfiniteScroll()
                    })
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension ImageSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if currentSearchTerm == searchBar.text {
            return
        }
        currentSearchTerm = searchBar.text!.lowercaseString
        navigationItem.title = searchBar.text!
        currentPage = 1
        DataServiceManager.sharedManager.fetchPhotos(withSearchTerm: currentSearchTerm, page: currentPage, photosPerPage: NumberOfColumns * 10) { (success, photoItems, error) in
            if success {
                self.photoItems = photoItems
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ImageSearchViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageSearchCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! ImageSearchCollectionViewCell
        cell.populate(withImageURL: photoItems[indexPath.item].imageURLThumbnail)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize = floor(CGRectGetWidth(collectionView.bounds) / CGFloat(NumberOfColumns))
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageDetailViewController = ImageDetailViewController(withPhotoItem: photoItems[indexPath.row])
        navigationController?.pushViewController(imageDetailViewController, animated: true)
    }
}
