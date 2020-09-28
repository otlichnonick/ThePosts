//
//  URLProtocolMock.swift
//  ThePosts
//
//  Created by Антон on 28.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var testURLs = [URL?: Data]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        if let url = request.url {
            if let data = URLProtocolMock.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {
    }
}
