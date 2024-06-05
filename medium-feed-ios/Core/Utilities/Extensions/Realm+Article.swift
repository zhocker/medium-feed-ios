//
//  Realm+Article.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation
import RealmSwift

extension RealmArticle {
    
    func toDomain() -> Article {
        return Article(title: title, link: link, content: content, creator: creator, pubDate: pubDate)
    }
    
    static func from(article: Article) -> RealmArticle {
        let realmArticle = RealmArticle()
        realmArticle.title = article.title
        realmArticle.link = article.link
        realmArticle.content = article.content
        realmArticle.creator = article.creator
        realmArticle.pubDate = article.pubDate
        return realmArticle
    }
}
