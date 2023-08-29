//
//  URLSessionHTTPClient.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

public final class URLSessionHTTPClient {
    struct Unexpected: Error {}
    
    static let shared = URLSessionHTTPClient()
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func perform(request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(Unexpected()))
            }
        }
    }
}
