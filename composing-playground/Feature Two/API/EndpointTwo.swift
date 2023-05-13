//
//  EndpointTwo.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum EndpointTwo {
    static func request(for base: URLRequest, value: String) -> URLRequest {
        var request = base
        request.httpBody = value.data(using: .utf8)
        request.httpMethod = "PUT"
        return request
    }
}
