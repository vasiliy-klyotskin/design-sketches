//
//  SwitchModel.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

struct SwitchModel {
    let isOn: Bool
    let isDisabled: Bool
    
    func new(isOn: Bool) -> SwitchModel {
        .init(isOn: isOn, isDisabled: isDisabled)
    }
}
