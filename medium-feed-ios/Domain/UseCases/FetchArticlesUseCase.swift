//
//  FetchArticlesUseCase.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation
import Combine

//class FetchArticlesUseCase {
//    private let repository: ArticleRepository
//
//    init(repository: ArticleRepository) {
//        self.repository = repository
//    }
//
//    func fetchArticles() -> AnyPublisher<[Article], Error> {
//        return Future<[Article], Error> { promise in
//            self.repository.loadLocalArticles { localArticles in
//                promise(.success(localArticles))
//                
//                self.repository.fetchArticles { result in
//                    switch result {
//                    case .success(let articles):
//                        promise(.success(articles))
//                        self.repository.saveArticles(articles)
//                    case .failure(let error):
//                        promise(.failure(error))
//                    }
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}

import Foundation
import Combine

class FetchArticlesUseCase {
    private let repository: ArticleRepository

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func fetchArticles() -> AnyPublisher<[Article], Error> {
        let localArticlesPublisher = Future<[Article], Error> { promise in
            self.repository.loadLocalArticles { articles in
                promise(.success(articles))
            }
        }
        .eraseToAnyPublisher()

        let remoteArticlesPublisher = Future<[Article], Error> { promise in
            self.repository.fetchArticles { result in
                switch result {
                case .success(let articles):
                    self.repository.saveArticles(articles)
                    promise(.success(articles))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()

        return localArticlesPublisher
            .append(remoteArticlesPublisher)
            .eraseToAnyPublisher()
    }
}
