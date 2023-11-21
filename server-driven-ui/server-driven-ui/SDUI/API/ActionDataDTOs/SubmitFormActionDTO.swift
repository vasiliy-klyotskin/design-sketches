//
//  SubmitFormActionDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct SubmitFormActionDTO: Decodable {
    let url: URL
    let ids: [String]
    
    var model: SubmitFormAction {
        .init(url: url, ids: ids.map { AnyHashable($0) })
    }
}
