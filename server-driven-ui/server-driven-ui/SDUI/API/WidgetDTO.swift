//
//  WidgetDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct WidgetDTO: Decodable {
    let type: String
    let instance: String
    let data: AnyCodable
    let positioning: AnyCodable?
    let children: [WidgetDTO]?
    let actions: [ActionDTO]?
}
