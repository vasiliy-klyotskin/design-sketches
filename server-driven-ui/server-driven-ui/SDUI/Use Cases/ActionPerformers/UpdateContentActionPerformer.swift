//
//  UpdateContentActionPerformer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

// TODO: Не готово, доделать

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
        action.updations.widgets.values.forEach { widget in
            storage.update(widget, for: widget.id.instance)
        }
        rerender()
    }
}
