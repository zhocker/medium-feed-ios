//
//  RSSParser.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    private var rssFeed: RSSFeed?
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentContent = ""
    private var currentCreator = ""
    private var currentPubDate = ""
    private var currentArticle: Article?

    var articles: [Article] = []

    func parse(data: Data) -> RSSFeed? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return rssFeed
    }

    // MARK: - XMLParserDelegate methods
    func parserDidStartDocument(_ parser: XMLParser) {
        rssFeed = RSSFeed(title: "", description: "", link: "", articles: [])
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "item" {
            currentArticle = Article(title: "", link: "", content: "", creator: "", pubDate: "")
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedString.isEmpty {
            switch currentElement {
            case "title":
                if currentArticle != nil {
                    currentTitle += trimmedString
                } else {
                    rssFeed?.title += trimmedString
                }
            case "link":
                currentLink += trimmedString
            case "dc:creator":
                currentCreator += trimmedString
            case "pubDate":
                currentPubDate += trimmedString
            case "content:encoded":
                currentContent += trimmedString
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let currentArticle = currentArticle {
                articles.append(Article(title: currentTitle,
                                        link: currentLink,
                                        content: currentContent,
                                        creator: currentCreator,
                                        pubDate: currentPubDate))
            }
            currentTitle = ""
            currentLink = ""
            currentContent = ""
            currentCreator = ""
            currentPubDate = ""
            currentArticle = nil
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        rssFeed?.articles = articles
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parse error: \(parseError.localizedDescription)")
    }
}
