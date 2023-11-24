//
//  ScrollModel.swift
//  server-driven-ui
//
//  Created by Марина Чемезова on 23.11.2023.
//

import Foundation

enum ScrollingDirection {
    case vertical
    case horizontal
    case both
}

struct ScrollModel {
    let direction: ScrollingDirection
    let contentInsets: Inset
}

