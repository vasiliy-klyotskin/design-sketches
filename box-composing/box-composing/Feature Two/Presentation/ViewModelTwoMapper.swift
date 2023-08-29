//
//  ViewModelTwoMapper.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum ViewModelTwoMapper {
    static func from(model: ModelTwo) -> ViewModelTwo {
        .init(prop1: model.prop1, prop2: model.prop2)
    }
}
