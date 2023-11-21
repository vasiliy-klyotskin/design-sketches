//
//  LabelDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct LabelDTO: Decodable {
    let text: String
    
    var model: LabelModel {
        .init(text: text)
    }
}
