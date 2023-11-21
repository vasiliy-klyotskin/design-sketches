//
//  IntentHandler.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

protocol IntentHandler {
    func handle(intent: IntentId, instance: WidgetInstanceId)
}
