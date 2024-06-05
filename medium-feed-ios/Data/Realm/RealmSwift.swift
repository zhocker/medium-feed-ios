//
//  RealmSwift.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation
import RealmSwift

class RealmArticle: Object {
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var pubDate: String = ""
    @objc dynamic var creator: String = ""
    
    override static func primaryKey() -> String? {
        return "pubDate"
    }
    
}
