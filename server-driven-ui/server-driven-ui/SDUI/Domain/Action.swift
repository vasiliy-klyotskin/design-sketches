//
//  Action.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/20/23.
//

import Foundation

typealias IntentId = AnyHashable
typealias ActionTypeId = AnyHashable
typealias ActionModel = Data

struct Action {
    let intent: IntentId
    let type: ActionTypeId
    let data: ActionModel
}
