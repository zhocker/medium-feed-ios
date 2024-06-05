//
//  HomeViewModel.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation

class HomeViewModel {
    private let fetchArticlesUseCase: FetchArticlesUseCase
    private var articles: [Article] = []
    
    var onArticlesUpdated: (() -> Void)?
    var onArticleSelected: ((Article) -> Void)?

    init(fetchArticlesUseCase: FetchArticlesUseCase) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
    }

    func loadArticles() {
        fetchArticlesUseCase.fetchArticles { [weak self] articles in
            self?.articles = articles
            self?.onArticlesUpdated?()
        }
    }
    
    var numberOfArticles: Int {
        return articles.count
    }

    func article(at index: Int) -> Article {
        return articles[index]
    }
    
    func didSelectArticle(at index: Int) {
        let article = articles[index]
        onArticleSelected?(article)
    }
}
