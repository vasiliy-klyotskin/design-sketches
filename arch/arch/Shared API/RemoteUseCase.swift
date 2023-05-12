//
//  RemoteUseCase.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

final class RemoteUseCase<DTO: Decodable, Model> {
    struct APIError: Error {}
    typealias RemoteMapping = (DTO) -> Model
    
    private let client: HTTPClient
    private let mapping: RemoteMapping
    
    init(client: HTTPClient, mapping: @escaping RemoteMapping) {
        self.client = client
        self.mapping = mapping
    }
    
    func load(from request: URLRequest, completion: @escaping (Result<Model, Error>) -> ()) {
        client.perform(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(Result {
                    let dto = try self.map(data: data, response: response)
                    return self.mapping(dto)
                })
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func map(data: Data, response: HTTPURLResponse) throws -> DTO {
        guard isOk(response) else { throw APIError() }
        return try JSONDecoder().decode(DTO.self, from: data)
    }
    
    private func isOk(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
}
