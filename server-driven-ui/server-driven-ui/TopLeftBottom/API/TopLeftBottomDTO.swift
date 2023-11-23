//
//  TrioContainerDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct TopLeftBottomDTO: Decodable {
    var model: TopLeftBottomModel {
        .init()
    }
}

struct TopLeftBottomPositioningDTO: Decodable {
    let top: String?
    let left: String?
    let bottom: String?
    
    var model: TopLeftBottomPositioning {
        .init(top: top, left: left, bottom: bottom)
    }
}
