//
//  InMemoryWidgetStorage.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/20/23.
//

import Foundation

final class InMemoryWidgetDataStorage {
    private var widgets: [WidgetInstanceId: Widget] = [:]
    
    func getWidgets() -> [WidgetInstanceId: Widget] {
        widgets
    }
    
    func getWidget(for id: WidgetInstanceId) -> Widget? {
        widgets[id]
    }
    
    func getWidgetData(for id: WidgetInstanceId) -> WidgetData? {
        widgets[id]?.data
    }
    
    func getActions(for id: WidgetInstanceId) -> [Action] {
        widgets[id]?.actions ?? []
    }
    
    func update(_ widget: Widget, for id: WidgetInstanceId) {
        widgets[id] = widget
    }
    
    func update(_ data: WidgetData, for id: WidgetInstanceId) {
        guard let oldWidget = widgets[id] else { return }
        widgets[id] = oldWidget.with(new: data)
    }
    
    func delete(for id: WidgetInstanceId) {
        widgets[id] = nil
    }
}
