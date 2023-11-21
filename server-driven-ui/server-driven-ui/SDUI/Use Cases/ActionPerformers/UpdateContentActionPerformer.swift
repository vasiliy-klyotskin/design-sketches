//
//  UpdateContentActionPerformer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

typealias UpdateContentRenderer = () -> Void

final class UpdateContentActionPerformer {
    private let action: UpdateContentAction
    private let storage: InMemoryWidgetDataStorage
    private let rerender: UpdateContentRenderer
    
    init(
        action: UpdateContentAction,
        storage: InMemoryWidgetDataStorage,
        rerender: @escaping UpdateContentRenderer
    ) {
        self.action = action
        self.storage = storage
        self.rerender = rerender
    }
    
    func perform() {
        action.deletions.forEach { instanceId in
            storage.delete(for: instanceId)
        }
        action.updations.forEach { (instanceId, model) in
            storage.update(model, for: instanceId)
        }
        rerender()
    }
}