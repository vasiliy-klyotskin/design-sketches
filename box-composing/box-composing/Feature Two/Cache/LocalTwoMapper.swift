//
//  LocalTwoMapper.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum LocalTwoMapper {
    static func toModel(_ local: LocalTwo) -> ModelTwo {
        .init(prop1: local.prop1, prop2: local.prop2)
    }
    
    static func fromModel(_ model: ModelTwo) -> LocalTwo {
        .init(prop1: model.prop1, prop2: model.prop2)
    }
}
