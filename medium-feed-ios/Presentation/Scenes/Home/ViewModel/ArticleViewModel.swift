//
//  ArticleViewModel.swift
//  medium-feed-ios
//
//  Created by User on 5/6/2567 BE.
//

import Foundation

struct ArticleViewModel {
    let title: String
    let description: String
    let date: String
    let content: String
    let imageURL: String

    init(article: Article) {
        self.title = article.title
        self.date = article.pubDate
        self.content = article.content
        
        // Use a local variable to store the result
        let extractedImageURL = ArticleViewModel.extractImageURL(from: article.content)
        self.imageURL = extractedImageURL ?? ""
        
        let extractSomeContent = ArticleViewModel.extractSomeContent(from: article.content)
        self.description = extractSomeContent

    }

    // Make this method static since it doesn't depend on instance properties
    private static func extractImageURL(from content: String) -> String? {
        // Simple regex to extract the first image URL from content
        let pattern = "<img[^>]+src=\"([^\"]+)\""
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = content as NSString
        let results = regex?.matches(in: content, options: [], range: NSMakeRange(0, nsString.length))
        let firstResult = results?.first
        
        if let range = firstResult?.range(at: 1) {
            return nsString.substring(with: range)
        }
        
        return nil
    }
    
    private static func extractSomeContent(from content: String) -> String {
        // Remove HTML tags for the summary
        let strippedString = content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        // Limit the snippet to a certain number of characters or words
        // Example: 200 characters
        let maxLength = 200
        if strippedString.count > maxLength {
            let index = strippedString.index(strippedString.startIndex, offsetBy: maxLength)
            return String(strippedString[..<index]) + "..."
        } else {
            return strippedString
        }
    }
}
