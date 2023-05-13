//
//  Endpoint.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

extension URLRequest {
    static func base() -> URLRequest {
        var request = URLRequest(url: URL(string: "backend shared url")!)
        request.httpBody = UUID().uuidString.data(using: .utf8)
        request.httpMethod = "POST"
        return request
    }
}
