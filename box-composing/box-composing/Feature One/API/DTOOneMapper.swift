//
//  DTOOneMapper.swift
//  box-composing
//
//  Created by Василий Клецкин on 10.05.2023.
//

import Foundation

enum DTOOneMapper {
    static func toModel(_ dto: DTOOne) -> ModelOne {
        .init(prop1: dto.prop1, prop2: dto.prop2)
    }
}
