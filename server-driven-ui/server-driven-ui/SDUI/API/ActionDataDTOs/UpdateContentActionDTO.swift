//
//  UpdateContentActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct UpdateContentActionDTO: Decodable {
    let deletionIds: [String]
    let updationIds: [String]
    let updationData: [AnyCodable]
    
    var model: UpdateContentAction {
        let encoder = JSONEncoder()
        let deletions = deletionIds.map { AnyHashable($0) }
        let updationIds = updationIds.map { AnyHashable($0) }
        let updationData = updationData.compactMap { try? encoder.encode($0) }
        return .init(
            updations: zip(updationIds, updationData).map {$0},
            deletions: deletions
        )
    }
}
