//
//  ActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct ActionDTO: Decodable {
    let type: String
    let intent: String
    let data: AnyCodable
}
