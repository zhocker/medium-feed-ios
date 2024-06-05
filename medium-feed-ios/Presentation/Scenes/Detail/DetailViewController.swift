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

class DetailViewController: UIViewController {
    private let article: Article
    private var webView: WKWebView!
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
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
        guard let url = URL(string: article.link) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 1, alpha: 1)

        // Set up WKWebView
        webView = WKWebView()
        webView.navigationDelegate = self
        
        // Add WKWebView to the view
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Load the content into the web view
        if let contentHTML = createContentHTML(article: article) {
            webView.loadHTMLString(contentHTML, baseURL: nil)
        }
    }
    
    private func createContentHTML(article: Article) -> String? {
        let formattedDate = article.pubDate
        
        // Enhanced HTML Template with Medium-like CSS styling
        let htmlTemplate = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                    padding: 20px;
                    margin: 0;
                    background: #fff;
                    color: #333;
                }
                img {
                    max-width: 100%;
                    height: auto;
                    display: block;
                    margin: 20px 0;
                }
                h1 {
                    font-size: 32px;
                    font-weight: 700;
                    line-height: 1.4;
                    margin: 20px 0;
                }
                .date {
                    font-size: 16px;
                    color: #888;
                    margin-bottom: 20px;
                }
                p, li, blockquote {
                    font-size: 20px;
                    line-height: 1.8;
                    margin: 16px 0;
                }
                blockquote {
                    margin-left: 20px;
                    padding-left: 10px;
                    border-left: 4px solid #ddd;
                    color: #555;
                    font-style: italic;
                }
                code {
                    font-family: "Fira Code", "Fira Mono", Menlo, Consolas, "DejaVu Sans Mono", monospace;
                    font-size: 18px;
                    background: #eee;
                    padding: 2px 4px;
                    border-radius: 4px;
                    margin: 0 2px;
                }
            </style>
        </head>
        <body>
            <h1>\(article.title)</h1>
            <div class="date">\(formattedDate)</div>
            \(article.content)
        </body>
        </html>
        """
        return htmlTemplate
    }
}

// Make DetailViewController conform to WKNavigationDelegate
extension DetailViewController: WKNavigationDelegate {
    // Implement any navigation delegate methods if needed
}
