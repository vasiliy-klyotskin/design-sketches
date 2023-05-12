//
//  RemoteLoaderBuilders.swift
//  arch
//
//  Created by Василий Клецкин on 12.05.2023.
//

import Foundation

enum RemoteBuilder<Model, DTO: Decodable> {
    typealias Mapping = (DTO) -> Model
    
    static func remote(for request: URLRequest, mapping: @escaping Mapping) -> Box<Model> {
        let client = URLSessionHTTPClient.shared
        let remote = RemoteUseCase(client: client, mapping: mapping)
        let curried = curry(remote.load)
        return Box(nullCancellable(curried(request)))
    }
}
