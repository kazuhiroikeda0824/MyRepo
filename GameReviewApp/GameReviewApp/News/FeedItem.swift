//
//  FeedItem.swift
//  GameReviewApp
//
//  Created by 池田一篤 on 2022/06/15.
//

import Foundation

class FeedItem {
    
    var title: String
    var link: String
    var pubDate: String
    
    init() {
        self.title = ["title"] as? String ?? ""
        self.link = ["link"] as? String ?? ""
        self.pubDate = ["pubDate"] as? String ?? ""
    }
}
