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
    
    func load(from request: URLRequest) throws -> Model {
        let (data, response) = try client.perform(request: request)
        let dto = try map(data: data, response: response)
        return mapping(dto)
    }
    
    private func map(data: Data, response: HTTPURLResponse) throws -> DTO {
        guard isOk(response) else { throw APIError() }
        return try JSONDecoder().decode(DTO.self, from: data)
    }
    
    private func isOk(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
}
