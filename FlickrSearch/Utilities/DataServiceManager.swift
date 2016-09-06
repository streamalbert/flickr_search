//
//  DataServiceManager.swift
//  FlickrSearch
//
//  Created by Weichuan Tian on 9/5/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let FlickrAPIKey = "e41f8d6643979ad7e23054a952d74ec2"
private let FlickrAPISecret = "561fc14c9b7a511e"

class DataServiceManager {

    // MARK: - Properties
    static let sharedManager = DataServiceManager()

    // MARK: - Public APIs
    func fetchPhotos(withSearchTerm term: String, page: Int, photosPerPage: Int, completionHandler: ((success: Bool, photoItems: [PhotoItemDataModel], error: String?) -> Void)?) {

        // This API fails ofter because of the wrong JSON parsing. http://stackoverflow.com/q/38601572
        // http://api.flickr.com/services/feeds/photos_public.gne?tags=cats&lang=en-us&format=json&nojsoncallback=1

//        https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=e41f8d6643979ad7e23054a952d74ec2&tags=cat&per_page=20&format=json&nojsoncallback=1
        let url = "https://api.flickr.com/services/rest"
        let params: [String: AnyObject] = [
            "method": "flickr.photos.search",
            "api_key": FlickrAPIKey,
            "tags": term,
            "lang": "en-us",
            "per_page": photosPerPage,
            "page": page,
            "format": "json",
            "nojsoncallback": 1
        ]

        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .Success(let json):
                if let response = json as? NSDictionary,
                    photos = response["photos"] as? NSDictionary,
                    items = photos["photo"] as? NSArray {

                    var photoItems: [PhotoItemDataModel] = []
                    items.forEach({
                        photoItems.append(PhotoItemDataModel(json: JSON($0)))
                    })
                    completionHandler?(success: true, photoItems: photoItems, error: nil)
                }
                else {
                    print("Error parsing \(#function) response.")
                    completionHandler?(success: false, photoItems: [], error: "Error parsing \(#function) response.")
                }
            case .Failure(let error):
                print("Request \(#function) failed with error: \(error).")
                completionHandler?(success: false, photoItems: [], error: "Request \(#function) failed with error: \(error).")
            }
        }
    }
}