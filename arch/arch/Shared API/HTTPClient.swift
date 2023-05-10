//
//  HTTPClient.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

public protocol HTTPClient {
    func perform(request: URLRequest) throws -> (Data, HTTPURLResponse)
}
