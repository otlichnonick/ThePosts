//
//  PostModel.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class PostModel {
    let authorName: String
    let postText: String
    let dateCreated: String
    let commentsCount: Int
    let viewsCount: Int
    
    init(authorName: String, postText: String, dateCreated: String, commentsCount: Int, viewsCount: Int) {
        self.authorName = authorName
        self.postText = postText
        self.dateCreated = dateCreated
        self.commentsCount = commentsCount
        self.viewsCount = viewsCount
    }
}
