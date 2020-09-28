//
//  APIRequestLoader.swift
//  ThePosts
//
//  Created by Антон on 28.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class APIRequestLoader<T: APIRequest> {
    
    let apiRequest: T
    let urlSession: URLSession
    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    func loadAPIRequest(requestData: T.RequestDataType, completionHandler: @escaping (T.ResponseDataType?) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data else { return completionHandler(nil) }
                    let parseResponse = self.apiRequest.parseResponse(safeData: data)
                completionHandler(parseResponse)
            }.resume()
        } catch {
            completionHandler(nil)
        }
    }
}
