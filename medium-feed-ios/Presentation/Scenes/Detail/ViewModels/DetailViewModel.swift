//
//  DetailViewModel.swift
//  medium-feed-ios
//
//  Created by User on 5/6/2567 BE.
//

import Foundation
import Combine

class DetailViewModel {
    private let article: Article

    init(article: Article) {
        self.article = article
    }
    
    var contentHTMLPublisher: AnyPublisher<String, Never> {
        return Just(createContentHTML(article: article))
            .eraseToAnyPublisher()
    }
    
    private func createContentHTML(article: Article) -> String {
        let formattedDate = article.pubDate
        
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
    
    // Expose URL for Safari
    var articleURL: URL? {
        return URL(string: article.link)
    }
}
