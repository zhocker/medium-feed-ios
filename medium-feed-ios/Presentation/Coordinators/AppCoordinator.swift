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
    private var homeViewController: HomeViewController? = nil

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
            guard let self = self, let vc = self.homeViewController, let nav = vc.navigationController else {
                return
            }
            print(article)
            self.showDetailScreen(article: article, nav: nav)
        }
        self.homeViewController = HomeViewController(viewModel: viewModel)
        if let homeViewController = self.homeViewController {
            navigationController.setViewControllers([homeViewController], animated: false)
        }
    }
    
    private func showDetailScreen(article: Article, nav: UINavigationController) {
        let detailViewController = DetailViewController(article: article)
        nav.pushViewController(detailViewController, animated: true)
    }
    
}
