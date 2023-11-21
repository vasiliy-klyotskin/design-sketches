//
//  ActivityDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct ActivityDTO: Codable {
    let isActive: Bool
    
    var model: ActivityModel {
        .init(isActive: isActive)
    }
    
    static func from(model: ActivityModel) -> ActivityDTO {
        .init(isActive: model.isActive)
    }
}
