//
//  RefreshActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct RefreshActionDTO: Decodable {
    let idsForDataToProvide: [String]
    
    var model: RefreshAction {
        .init(idsForDataToProvide: idsForDataToProvide.map { AnyHashable($0) })
    }
}
