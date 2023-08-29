//
//  EndpointOne.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum EndpointOne {
    static func request(for base: URLRequest) -> URLRequest {
        var request = base
        request.httpBody = UUID().uuidString.data(using: .utf8)
        request.httpMethod = "GET"
        return request
    }
}
