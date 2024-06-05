//
//  ArticleRepository.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation
import RealmSwift
import Moya

protocol ArticleRepository {
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void)
    func saveArticles(_ articles: [Article])
    func loadLocalArticles(completion: @escaping ([Article]) -> Void)
}

class DefaultArticleRepository: ArticleRepository {
    private let provider = MoyaProvider<ArticleService>()

    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        provider.request(.fetchArticles) { result in
            switch result {
            case .success(let response):
                do {
                    let articles = try self.parse(data: response.data)
                    completion(.success(articles))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveArticles(_ articles: [Article]) {
        DispatchQueue(label: "realm.save.queue").async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    let realmArticles = articles.map { RealmArticle.from(article: $0) }
                    realm.add(realmArticles, update: .modified)
                }
            }
        }
    }
    
    func loadLocalArticles(completion: @escaping ([Article]) -> Void) {
        DispatchQueue(label: "realm.load.queue").async {
            autoreleasepool {
                let realm = try! Realm()
                let realmArticles = realm.objects(RealmArticle.self)
                let articles: [Article] = realmArticles.map { $0.toDomain() }
                
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        }
    }
    
    private func parse(data: Data) throws -> [Article] {
        let parser = RSSParser()
        if let rssFeed = parser.parse(data: data) {
            return rssFeed.articles
        }
        return []
    }
    
}
