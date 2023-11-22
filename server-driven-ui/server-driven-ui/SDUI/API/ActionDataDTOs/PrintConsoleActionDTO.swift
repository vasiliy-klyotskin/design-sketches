//
//  PrintConsoleActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/22/23.
//

import Foundation

struct PrintConsoleActionDTO: Decodable {
    let text: String
    
    var model: PrintConsoleAction {
        .init(text: text)
    }
}
