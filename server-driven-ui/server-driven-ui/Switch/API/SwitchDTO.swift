//
//  SwitchDTO.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct SwitchDTO: Codable {
    let isOn: Bool
    let isDisabled: Bool
    
    var model: SwitchModel {
        .init(isOn: isOn, isDisabled: isDisabled)
    }
    
    static func from(model: SwitchModel) -> SwitchDTO {
        .init(isOn: model.isOn, isDisabled: model.isDisabled)
    }
}
