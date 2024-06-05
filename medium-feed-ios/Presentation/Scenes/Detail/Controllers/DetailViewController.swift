//
//  DetailViewController.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import UIKit
import WebKit
import SnapKit
import SafariServices
import Combine

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var webView: WKWebView!
    private var cancellables = Set<AnyCancellable>()
    
    init(article: Article) {
        self.viewModel = DetailViewModel(article: article)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        title = "Detail"
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        // Add right button to open in Safari
        let safariButton = UIBarButtonItem(title: "Full Read", style: .plain, target: self, action: #selector(openInSafari))
        safariButton.tintColor = .black
        navigationItem.rightBarButtonItem = safariButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openInSafari() {
        guard let url = viewModel.articleURL else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 1, alpha: 1)

        webView = WKWebView()
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.contentHTMLPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contentHTML in
                self?.webView.loadHTMLString(contentHTML, baseURL: nil)
            }
            .store(in: &cancellables)
    }
}

extension DetailViewController: WKNavigationDelegate {
    
}
