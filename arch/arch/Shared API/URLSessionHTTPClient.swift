//
//  URLSessionHTTPClient.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    struct Unexpected: Error {}
    
    static var shared: URLSessionHTTPClient = URLSessionHTTPClient()
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func perform(request: URLRequest) throws -> (Data, HTTPURLResponse) {
        let result = syncDataTask(request)
        if let data = result.data, let response = result.response as? HTTPURLResponse {
            return (data, response)
        } else if let error = result.error {
            throw error
        } else {
            throw Unexpected()
        }
    }
    
    typealias HTTPResult = (data: Data?, response: URLResponse?, error: Error?)
    
    private func syncDataTask(_ request: URLRequest) -> HTTPResult {
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?
        var error: Error?
        var response: URLResponse?
        urlSession.dataTask(with: request) { receivedData, receivedResponse, receivedError in
            data = receivedData
            response = receivedResponse
            error = receivedError
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return (data, response, error)
    }
}
