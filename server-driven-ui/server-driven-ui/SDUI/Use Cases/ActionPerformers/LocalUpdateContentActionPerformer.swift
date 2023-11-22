//
//  UpdateContentActionPerformer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

typealias LocalUpdateContentRenderer = () -> Void

final class LocalUpdateContentActionPerformer {
    private let action: LocalUpdateContentAction
    private let storage: InMemoryWidgetDataStorage
    private let rerender: LocalUpdateContentRenderer
    
    init(
        action: LocalUpdateContentAction,
        storage: InMemoryWidgetDataStorage,
        rerender: @escaping LocalUpdateContentRenderer
    ) {
        self.action = action
        self.storage = storage
        self.rerender = rerender
    }
    
    func perform() {
        removeWidgets()
        updateWidgets()
        insertWidgets()
        rerender()
    }
    
    private func removeWidgets() {
        action.removals.forEach { id in
            storage.delete(for: id)
        }
    }
    
    private func updateWidgets() {
        action.updates.forEach { update in
            storage.update(update.data, for: update.instanceId)
        }
    }
    
    private func insertWidgets() {
        let currentHeirarchy = storage.getHeirarchy()
        action.insertions.forEach { insertion in
            updateParentFor(insertion: insertion, in: currentHeirarchy)
            insertWidgetsFrom(heirarchy: insertion.heirarchy)
        }
    }
    
    private func updateParentFor(
        insertion: LocalUpdateContentAction.Insertion,
        in currentHeirarchy: WidgetHeirarchy
    ) {
        let currentWidgets = currentHeirarchy.widgets
        guard let parent = currentWidgets[insertion.parentInstanceId] else { return }
        guard let child = insertion.heirarchy.root else { return }
        var children = parent.children
        children.insert(child.id.instance, at: insertion.index)
        let newParent = parent.copyWith(children: children)
        storage.update(newParent, for: insertion.parentInstanceId)
    }
    
    private func insertWidgetsFrom(heirarchy: WidgetHeirarchy) {
        heirarchy.allWidgets.forEach {
            storage.update($0, for: $0.id.instance)
        }
    }
}
