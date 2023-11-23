//
//  LinearPositioningDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

// TODO: Подумать над тем, чтоб хранить общие Positioning отдельно от конкретного виджета (Например, где-то в папке SDUI)

typealias LinearPositioningDTO = [String]

extension LinearPositioningDTO {
    var model: LinearPositioning {
        .init(items: self)
    }
}
