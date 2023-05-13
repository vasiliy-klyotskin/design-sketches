//
//  RemoteUseCase.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum DTOMapper<DTO: Decodable> {
    struct APIError: Error {}
    
    static func map(data: Data, response: HTTPURLResponse) throws -> DTO {
        guard isOk(response) else { throw APIError() }
        return try JSONDecoder().decode(DTO.self, from: data)
    }
    
    static func isOk(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
}
