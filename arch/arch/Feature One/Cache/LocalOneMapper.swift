//
//  LocalOneMapper.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum LocalOneMapper {
    static func toModel(_ local: LocalOne) -> ModelOne {
        .init(prop1: local.prop1, prop2: local.prop2)
    }
    
    static func fromModel(_ model: ModelOne) -> LocalOne {
        .init(prop1: model.prop1, prop2: model.prop2)
    }
}
