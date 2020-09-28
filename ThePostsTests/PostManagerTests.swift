//
//  PostManagerTests.swift
//  ThePostsTests
//
//  Created by Антон on 28.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation
import XCTest

@testable import ThePosts

class PostManagerTests: XCTestCase {
    
    var loader: APIRequestLoader<PostManager>!

    override func setUp() {
        let request = PostManager()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MocURLProtokol.self]
        let urlSession = URLSession(configuration: configuration)
        loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MocURLProtokol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse?, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        returnMocResponse()
    }
    
    override func stopLoading() {
        returnMocResponse()
    }
    
    func returnMocResponse() {
        guard let handler = MocURLProtokol.requestHandler else {
            XCTFail("Recieved unexpected request with handler set.")
            return
        }
        do {
            let (response, data, error) = try handler(request)
            
            if let response = response { client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed) }
            if let data = data { client?.urlProtocol(self, didLoad: data); client?.urlProtocolDidFinishLoading(self) }
            if let error = error { client?.urlProtocol(self, didFailWithError: error) }
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
