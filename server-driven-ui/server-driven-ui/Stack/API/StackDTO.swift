//
//  StackDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct StackDTO: Decodable {
    let spacing: Double
    
    var model: StackModel {
        .init(spacing: spacing)
    }
}
