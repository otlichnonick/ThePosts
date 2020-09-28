//
//  PostManager.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class PostManager: APIRequest {
    
    var postsCashe = NSCache<NSString, NSArray>()
    
    var cursorString: String?
    
    typealias RequestDataType = String
    
    typealias ResponseDataType = [PostModel]?
    
    enum RequestError: String, Error {
        case invalidURL = "This is an invalid url."
        case invalidSafeData = "There are no valid data in safeData."
        case invalidSession = "Could not create a session."
        case invalidData = "Where are no data."
    }
    
    func makeRequest(from urlString: String) throws -> URLRequest {
        guard let urlPosts = URL(string: K.baseURL + urlString) else {
            throw RequestError.invalidURL
        }
        return URLRequest(url: urlPosts)
    }
    
    func parseResponse(safeData: Data) -> [PostModel]? {
        let decoder = JSONDecoder()
        do {
            var array = [PostModel]()
            let result = try decoder.decode(PostData.self, from: safeData)
            self.cursorString = result.data?.cursor
            guard let pospsArray = result.data?.items  else { throw RequestError.invalidSafeData }
            for post in pospsArray {
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
            return array
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchResults(with query: String, closure: @escaping ([PostModel]?) -> Void) {
        if let cashedPosts = postsCashe.object(forKey: query as NSString) {
            closure(cashedPosts as? [PostModel])
        } else {
            guard let request = try? makeRequest(from: query) else { return }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(RequestError.invalidSession); return }
                guard let safeData = data else { print(RequestError.invalidData); return }
                let posts = self.parseResponse(safeData: safeData)
                self.postsCashe.setObject(posts! as NSArray, forKey: query as NSString)
                DispatchQueue.main.async {
                    closure(posts)
                }
            }.resume()
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

protocol APIRequest {
    
    associatedtype RequestDataType
    associatedtype ResponseDataType
    func makeRequest(from urlString: RequestDataType) throws -> URLRequest
    func parseResponse(safeData: Data) -> ResponseDataType
}

