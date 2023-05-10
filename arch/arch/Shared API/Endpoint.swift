//
//  Endpoint.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

extension URLRequest {
    static func base() -> URLRequest {
        .init(url: URL(string: "backend url")!)
    }
}
