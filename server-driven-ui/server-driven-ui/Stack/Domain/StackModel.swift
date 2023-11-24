//
//  StackModel.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import Foundation

enum StackAxis {
    case vertical
    case horizontal
}

struct StackModel {
    let axis: StackAxis
    let spacing: Double
}
