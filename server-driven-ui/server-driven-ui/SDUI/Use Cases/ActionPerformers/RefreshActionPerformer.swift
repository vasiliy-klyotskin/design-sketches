//
//  RefreshActionPerformer.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

typealias RefreshHandler = ([WidgetInstanceId: WidgetData]) -> Void

class RefreshActionPerformer {
    let action: RefreshAction
    let storage: InMemoryWidgetDataStorage
    let refreshHandler: RefreshHandler
    
    init(
        action: RefreshAction,
        storage: InMemoryWidgetDataStorage,
        refreshHandler: @escaping RefreshHandler
    ) {
        self.storage = storage
        self.action = action
        self.refreshHandler = refreshHandler
    }
    
    func perform() {
        var dataToProvideDuringRefreshing = [WidgetInstanceId: WidgetData]()
        for id in action.idsForDataToProvide {
            guard let data = storage.getWidgetData(for: id) else { continue }
            dataToProvideDuringRefreshing[id] = data
        }
        refreshHandler(dataToProvideDuringRefreshing)
    }
}
