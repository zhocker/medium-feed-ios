//
//  HomeViewModel.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation
import Combine

class HomeViewModel {
    private let fetchArticlesUseCase: FetchArticlesUseCase
    private var articles: [Article] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Publishers
    @Published var items: [ArticleViewModel] = []
    @Published var error: String? = nil

    var onArticleSelected: ((Article) -> Void)?

    init(fetchArticlesUseCase: FetchArticlesUseCase) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
    }

    func loadArticles() {
        fetchArticlesUseCase.fetchArticles()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { articles in
                self.articles = articles
                self.items = articles.map { ArticleViewModel(article: $0) }
            })
            .store(in: &cancellables)
    }
    
    var numberOfArticles: Int {
        return items.count
    }

    func article(at index: Int) -> Article {
        return articles[index]
    }
    
    func didSelectArticle(at index: Int) {
        let article = articles[index]
        onArticleSelected?(article)
    }
    
}
