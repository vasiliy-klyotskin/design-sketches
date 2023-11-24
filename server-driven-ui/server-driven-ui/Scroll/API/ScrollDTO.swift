//
//  ScrollDTO.swift
//  server-driven-ui
//
//  Created by Марина Чемезова on 23.11.2023.
//

import Foundation

typealias ScrollPositioningDTO = String

extension ScrollPositioningDTO {
    var model: WidgetInstanceId {
        self
    }
}

enum ScrollingDirectionDTO: String, Decodable {
    case vertical
    case horizontal
    case both
}

struct ScrollDTO: Decodable {
    let direction: ScrollingDirectionDTO?
    let contentInsets: Inset?
}

extension ScrollingDirectionDTO {
    var model: ScrollingDirection {
        switch self {
        case .vertical: return .vertical
        case .horizontal: return .horizontal
        case .both: return .both
        }
    }
}

extension ScrollDTO {
    var model: ScrollModel {
        .init(
            direction: direction?.model ?? .vertical,
            contentInsets: contentInsets ?? .zero
        )
    }
}
