//
//  UpdateContentActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

// TODO: Не готово, доделать

struct UpdateContentActionDTO: Decodable {
    let insertions: [Insertion]
    let updations: [Insertion]
    let removals: [String]
    

    var model: UpdateContentAction {
        
    }
    
    struct Insertion: Decodable {
        let widget: WidgetDTO
        let parentInstanceId: String
        let index: Int
    }
    
    struct Update: Decodable {
        let data: AnyCodable
        let instanceId: String
    }
}
