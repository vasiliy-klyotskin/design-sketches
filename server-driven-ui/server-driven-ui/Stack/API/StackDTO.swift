//
//  StackDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

enum StackAxisDTO: String, Decodable {
    case vertical
    case horizontal
}

extension StackAxisDTO {
    var model: StackAxis {
        switch self {
        case .vertical: return .vertical
        case .horizontal: return .horizontal
        }
    }
}

struct StackDTO: Decodable {
    let axis: StackAxisDTO?
    let spacing: Double
}

extension StackDTO {
    var model: StackModel {
        .init(axis: axis?.model ?? .vertical, spacing: spacing)
    }
}
