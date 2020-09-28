//
//  PostData.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PostData: Codable {
    let data: ResultData?
}

// MARK: - WelcomeData
struct ResultData: Codable {
    let items: [Item]
    let cursor: String?
}

// MARK: - Item
struct Item: Codable {
    let contents: [Content]
    let createdAt: Int
    let author: Author?
    let stats: Stats

    enum CodingKeys: String, CodingKey {
        case contents, createdAt, author, stats
    }
}

// MARK: - Author
struct Author: Codable {
    let name: String
}

// MARK: - Banner
struct Banner: Codable {
    let type: BannerType
    let id: String
    let data: BannerData
}

// MARK: - BannerData
struct BannerData: Codable {
    let extraSmall: ExtraSmall
    let small: ExtraSmall?
    let original: ExtraSmall
}

// MARK: - ExtraSmall
struct ExtraSmall: Codable {
    let url: String
}

enum BannerType: String, Codable {
    case image = "IMAGE"
    case tags = "TAGS"
    case text = "TEXT"
    case audio = "AUDIO"
}

// MARK: - Content
struct Content: Codable {
    let type: BannerType
    let data: ContentData
    let id: String?
}

// MARK: - ContentData
struct ContentData: Codable {
    let value: String?
    let values: [String]?
}

// MARK: - Stats
struct Stats: Codable {
    let likes, views, comments, shares: Comments
}

// MARK: - Comments
struct Comments: Codable {
    let count: Int?
}

