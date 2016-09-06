//
//  PhotoItemDataModel.swift
//  FlickrSearch
//
//  Created by Weichuan Tian on 9/5/16.
//  Copyright © 2016 Weichuan Tian. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhotoItemDataModel {

    let id: String
    let title: String
    let imageURLThumbnail: String?
    let imageURLHighRes: String?

    init(json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        if let farmID = json["farm"].number,
            serverID = json["server"].string,
            imageID = json["id"].string,
            imageSecret = json["secret"].string {
            // image URL formatting: https://www.flickr.com/services/api/misc.urls.html
            let imageURL = "https://farm\(farmID).staticflickr.com/\(serverID)/\(imageID)_\(imageSecret)_"
            imageURLThumbnail = imageURL + "n.jpg"
            imageURLHighRes = imageURL + "b.jpg"
        }
        else {
            imageURLThumbnail = nil
            imageURLHighRes = nil
        }
    }
}
