//
//  IntentHandler.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/20/23.
//

import Foundation

typealias ActionPerformer = (ActionTypeId, ActionModel) -> Void

final class PerformActionIntentHandler: IntentHandler {
    let storage: InMemoryWidgetDataStorage
    let performer: ActionPerformer
    
    init(
        storage: InMemoryWidgetDataStorage,
        performer: @escaping ActionPerformer
    ) {
        self.storage = storage
        self.performer = performer
    }
    
    func handle(intent: IntentId, instance: WidgetInstanceId) {
        let actions = storage.getActions(for: instance)
        for action in actions {
            performActionIfIntentIdsAreEqual(action: action, intent: intent)
        }
    }
    
    private func performActionIfIntentIdsAreEqual(action: Action, intent: IntentId) {
        if action.intent == intent {
            performer(action.type, action.data)
        }
    }
}
