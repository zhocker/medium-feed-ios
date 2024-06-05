//
//  HomeViewModel.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import UIKit
import Foundation
import Combine

class HomeViewModel {
    private let fetchArticlesUseCase: FetchArticlesUseCase
    private var articles: [Article] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Publishers
    @Published var items: [ArticleViewModel] = []
    @Published var error: String? = nil
    @Published var isLoading: Bool = false

    init(fetchArticlesUseCase: FetchArticlesUseCase) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
    }

    func loadArticles() {
        isLoading = true
        fetchArticlesUseCase.fetchArticles()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] articles in
                guard let self = self else { return }
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
        
    func articleModel(at index: Int) -> ArticleViewModel {
        return items[index]
    }
        
}
