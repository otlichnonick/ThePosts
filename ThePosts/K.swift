//
//  K.swift
//  ThePosts
//
//  Created by Антон on 26.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "PostTableViewCell"
    static let baseURL = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
    static let titleSegmentControl = "Sorted by..."
    static let detailVCname = "DetailViewController"
    static let nameStoryboard = "Main"
    
    struct FilterName {
        static let mostPopular = "?orderBy=mostPopular"
        static let mostCommented = "?orderBy=mostCommented"
        static let createdAt = "?orderBy=createdAt"
        static let after = "?after="
        static let andAfter = "&after="
    }
    
    struct Sections {
        static let left = "mostPopular"
        static let middle = "mostCommented"
        static let right = "createdAt"
    }
}
