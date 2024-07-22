//
//  DataEntity.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation

struct DataEntity: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let description: String
    let pubDate: String
}
