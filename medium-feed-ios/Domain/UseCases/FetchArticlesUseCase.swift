//
//  FetchArticlesUseCase.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation

class FetchArticlesUseCase {
    private let repository: ArticleRepository

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func fetchArticles(completion: @escaping ([Article]) -> Void) {
        repository.loadLocalArticles { articles in
            completion(articles)
        }
        
        repository.fetchArticles { result in
            switch result {
            case .success(let articles):
                self.repository.saveArticles(articles)
                completion(articles)
            case .failure(let error):
                print("Error fetching articles:", error)
            }
        }
    }
}
