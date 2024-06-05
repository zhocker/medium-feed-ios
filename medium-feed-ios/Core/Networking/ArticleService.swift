//
//  ArticleService.swift
//  medium-feed-ios
//
//  Created by User on 5/6/2567 BE.
//

import Foundation
import Moya

enum ArticleService {
    case fetchArticles
}

extension ArticleService: TargetType {
    var baseURL: URL {
        return URL(string: "https://medium.com")!
    }

    var path: String {
        switch self {
        case .fetchArticles:
            return "/feed/@primoapp"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchArticles:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .fetchArticles:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
