//
//  UpdateContentActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct LocalUpdateContentActionDTO: Decodable {
    let insertions: [Insertion]?
    let updates: [Update]?
    let removals: [String]?
    
    var model: LocalUpdateContentAction {
        .init(
            insertions: insertions?.map { $0.model } ?? [],
            updates: updates?.compactMap { $0.model } ?? [],
            removals: removals?.map { AnyHashable($0) } ?? []
        )
    }
    
    struct Insertion: Decodable {
        let widget: WidgetDTO
        let parentInstanceId: String
        let index: Int
        
        var model: LocalUpdateContentAction.Insertion {
            .init(
                parentInstanceId: AnyHashable(parentInstanceId),
                heirarchy: WidgetDTOMapper.heirarchy(from: widget),
                index: index
            )
        }
    }
    
    struct Update: Decodable {
        let data: AnyCodable
        let instanceId: String
        
        var model: LocalUpdateContentAction.Update? {
            guard let widgetData = try? JSONEncoder().encode(data) else { return nil }
            return .init(instanceId: AnyHashable(instanceId), data: widgetData)
        }
    }
}
