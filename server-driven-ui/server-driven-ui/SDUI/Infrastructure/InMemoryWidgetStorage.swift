//
//  InMemoryWidgetStorage.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/20/23.
//

import Foundation

// TODO: Вынести абстракцию стореджа

final class InMemoryWidgetDataStorage {
    private var rootId: WidgetInstanceId?
    private var widgets: [WidgetInstanceId: Widget] = [:]
    
    func getHeirarchy() -> WidgetHeirarchy {
        WidgetHeirarchy(widgets: widgets, rootId: rootId)
    }
    
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
    
    func update(with heirarchy: WidgetHeirarchy) {
        widgets = heirarchy.widgets
        rootId = heirarchy.rootId
    }
    
    func update(_ data: WidgetData, for id: WidgetInstanceId) {
        guard let oldWidget = widgets[id] else { return }
        widgets[id] = oldWidget.copyWith(data: data)
    }
    
    func delete(for id: WidgetInstanceId) {
        widgets[id] = nil
    }
}
