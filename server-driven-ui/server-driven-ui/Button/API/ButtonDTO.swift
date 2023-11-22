//
//  ButtonDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct ButtonDTO: Decodable {
    let title: String
    
    var model: ButtonModel {
        .init(title: title, isDisabled: false)
    }
}
