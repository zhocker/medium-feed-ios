//
//  AppCoordinator.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol {
    func start()
}

class AppCoordinator: AppCoordinatorProtocol {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    // Dependencies
    private let articleRepository: ArticleRepository
    private let fetchArticlesUseCase: FetchArticlesUseCase
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.articleRepository = DefaultArticleRepository()
        self.fetchArticlesUseCase = FetchArticlesUseCase(repository: articleRepository)
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showHomeScreen()
    }
    
    private func showHomeScreen() {
        let viewModel = HomeViewModel(fetchArticlesUseCase: fetchArticlesUseCase)
        viewModel.onArticleSelected = { [weak self] article in
            self?.showDetailScreen(article: article)
        }
        let homeViewController = HomeViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([homeViewController], animated: false)
    }
    
    private func showDetailScreen(article: Article) {
        let detailViewController = DetailViewController(article: article)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
