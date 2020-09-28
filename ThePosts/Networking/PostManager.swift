//
//  PostManager.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class PostManager {
    
    var postsCashe = NSCache<NSString, NSArray>()
    
    var cursorString: String?
    
    func getLatestPosts(name: String, closure: @escaping ([PostModel]?, String?) -> Void) {
        let urlString = K.baseURL + name
        guard let url = URL(string: urlString) else { fatalError("Where is no URL.") }
        if let cashedPosts = postsCashe.object(forKey: url.absoluteString as NSString) {
            closure(cashedPosts as? [PostModel], cursorString)
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { fatalError("Could not create a session.")}
                guard let safeData = data else { fatalError("Where are no data.") }
                do {
                    var array = [PostModel]()
                    let result = try JSONDecoder().decode(PostData.self, from: safeData)
                    self.cursorString = result.data?.cursor
                    guard let itemCount = result.data?.items.count else {
                        DispatchQueue.main.async {
                            closure(nil, nil)
                        }
                        return
                    }
                    for item in 0..<itemCount {
                        guard let post = result.data?.items[item] else { fatalError("Where are no post in data") }
                        let dateCreated = self.convertDateFromWebToApp(jsonResult: Double(post.createdAt))
                        let commentsCount = post.stats.comments.count
                        let viewsCount = post.stats.views.count
                        let authorName = post.author?.name.replacingOccurrences(of: "\n", with: "")
                        var postText = ""
                        for item in 0..<post.contents.count {
                            switch post.contents[item].type {
                            case .text: postText = post.contents[item].data.value ?? "no value"
                            default: break
                            }
                        }
                        let newPost = PostModel(authorName: authorName ?? "no author", postText: postText, dateCreated: dateCreated, commentsCount: commentsCount ?? 0, viewsCount: viewsCount ?? 0)
                        array.append(newPost)
                    }
                    self.postsCashe.setObject(array as NSArray, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        closure(array, self.cursorString)
                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func convertDateFromWebToApp(jsonResult: Double) -> String {
        let date = Date(timeIntervalSince1970: jsonResult/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
}


