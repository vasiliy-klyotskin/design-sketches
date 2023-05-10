//
//  DTOTwoMapper.swift
//  arch
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum DTOTwoMapper {
    static func toModel(_ dto: DTOTwo) -> ModelTwo {
        .init(prop1: dto.prop1, prop2: dto.prop2)
    }
}
