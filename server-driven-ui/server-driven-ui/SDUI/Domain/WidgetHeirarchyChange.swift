//
//  WidgetHeirarchyChange.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

/// Структура, хранящая две иерархии виджетов - "предыдущую" и "текущую"
struct WidgetHeirarchyChange {
    // TODO: Rename: Previous, current
    let current: WidgetHeirarchy
    let previous: WidgetHeirarchy
    
    /// Виджеты, которые не содержатся в предыдущей иерархии, но содержаться в текущей
    var newWidgets: [Widget] {
        current.allInstanceIds.subtracting(previous.allInstanceIds).compactMap { current.widgets[$0] }
    }
    
    /// Виджеты, которые не содержатся в текущей иерархии, но содержаться в предыдущей
    var removedWidgets: [Widget] {
        previous.allInstanceIds.subtracting(current.allInstanceIds).compactMap { previous.widgets[$0] }
    }
    
    /// Виджеты, идентификаторы которых содержатся в текущей и предыдущей иерархиях
    var remainedWithTheSameInstanceIdWidgets: [(previous: Widget, current: Widget)] {
        current.allInstanceIds
            .intersection(previous.allInstanceIds)
            .compactMap {
                guard let previous = previous.widgets[$0] else { return nil }
                guard let current = current.widgets[$0] else { return nil }
                return (previous, current)
            }
    }
    
    /// Все виджеты, которые являются контейнерам
    var newContainers: [Widget] {
        newWidgets.filter { $0.isContainer }
    }
    
    /// Все виджеты, являющиеся контейнерами, которые содержатся в текущей и предыдущей иерархиях
    var remainedWithTheSameInstanceIdContainers: [(previous: Widget, current: Widget)] {
        remainedWithTheSameInstanceIdWidgets.filter { $0.current.isContainer }
    }
}
