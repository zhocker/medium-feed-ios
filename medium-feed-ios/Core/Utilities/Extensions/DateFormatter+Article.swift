//
//  File.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import Foundation

extension DateFormatter {
    static let articleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()
}

