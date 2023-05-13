//
//  ViewModelOneMapper.swift
//  composing-playground
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum ViewModelOneMapper {
    static func from(model: ModelOne) -> ViewModelOne {
        .init(prop1: model.prop1, prop2: model.prop2)
    }
}
