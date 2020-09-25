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
    
    let baseUrl = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
    
    var cursorString: String?
    
    enum DownloadType {
        case empty, sorted, after, afterSorted
    }
    
    enum FilterName {
        case mostPopular, mostCommented, createdAt
    }
    
    func filteredBy(_ filter: FilterName) -> (String, Int) {
        switch filter {
        case .mostPopular:
            return ("?orderBy=mostPopular", 0)
        case .mostCommented:
            return ("?orderBy=mostCommented", 1)
        case .createdAt:
            return ("?orderBy=createdAt", 2)
        }
    }
    
    func getLatestPosts(name: String, closure: @escaping ([PostModel], String?) -> Void) {
        let urlString = "\(baseUrl)\(name)"
        if let url = URL(string: urlString) {
            print(url)
            if let cashedPosts = postsCashe.object(forKey: url.absoluteString as NSString) {
                closure(cashedPosts as! [PostModel], cursorString)
            } else {
                let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard error == nil else { fatalError("Could not create a session. \(String(describing: error))")}
                    if let safeData = data {
                        do {
                            var array = [PostModel]()
                            let result = try JSONDecoder().decode(PostData.self, from: safeData)
                            let cursor = result.data?.cursor
                            self.cursorString = cursor
                            print("\(self.cursorString) - before closure")
                            if let itemCount = result.data?.items.count {
                                for item in 0..<itemCount {
                                    if let post = result.data?.items[item] {
                                        var postText = ""
                                        let contentsCount = post.contents.count
                                        for item in 0..<contentsCount {
                                            switch post.contents[item].type {
                                            case .text:
                                                postText = post.contents[item].data.value ?? "no value"
                                            default:
                                                break
                                            }
                                        }
                                        let dateCreated = self.convertDateFromWebToApp(jsonResult: Double(post.createdAt))
                                        let commentsCount = post.stats.comments.count
                                        let viewsCount = post.stats.views.count
                                        let authorName = post.author?.name.replacingOccurrences(of: "\n", with: "")
                                        let newPost = PostModel(authorName: authorName ?? "no author", postText: postText, dateCreated: dateCreated, commentsCount: commentsCount ?? 0, viewsCount: viewsCount ?? 0)
                                        array.append(newPost)
                                    }
                                }
                            }
                            self.postsCashe.setObject(array as NSArray, forKey: url.absoluteString as NSString)
                            DispatchQueue.main.async {
                                closure(array, self.cursorString)
                                print("\(self.cursorString) - after closure")
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func convertDateFromWebToApp(jsonResult: Double) -> String {
        let date = Date(timeIntervalSince1970: jsonResult / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
}


