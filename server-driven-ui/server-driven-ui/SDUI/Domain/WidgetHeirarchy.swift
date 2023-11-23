//
//  WidgetHeirarchy.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/23/23.
//

import Foundation

/// Иерархия виджетов
///
/// Поскольку информация о родительских и дочерних виджетах хранится в ``Widget``, способ хранения выбран самый простой: в виде хэш таблицы
struct WidgetHeirarchy {
    /// Виджеты
    let widgets: [WidgetInstanceId: Widget]
    
    /// Идентификатор корневого виджета дерева
    let rootId: WidgetInstanceId?
    
    /// Множество идентификаторов всех виджетов в дереве
    var allInstanceIds: Set<WidgetInstanceId> {
        Set(widgets.keys)
    }
    
    /// Возвращает список виджетов из ``widgets`` в виде несортированного массива
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    /// Возвращает корневой виджет, если он есть
    var root: Widget? {
        rootId.flatMap { widgets[$0] }
    }
    
    /// Возвращает дерево, корень которого обернут в дополнительную корневую ноду
    var wrappedIntoRootContainer: WidgetHeirarchy {
        let idKey = WidgetId.rootContainerKeyForIds
        let rootContainer = Widget(
            id: .init(type: idKey, instance: idKey, state: idKey, positioning: AnyHashable(rootId)),
            parent: idKey,
            children: [rootId].compactMap { $0 },
            data: .init(),
            positioning: .init(),
            actions: []
        )
        var newWidgets = widgets
        newWidgets.updateValue(rootContainer, forKey: idKey)
        guard let root, let rootId else { return .init(widgets: newWidgets, rootId: idKey)}
        newWidgets.updateValue(root.copyWith(parent: idKey), forKey: rootId)
        return .init(widgets: newWidgets, rootId: idKey)
    }
    
    /// Возвращает пустое дерево виджетов
    static var empty: WidgetHeirarchy {
        .init(widgets: [:], rootId: nil)
    }
    
    /// Создает WidgetHeirarchy с заданным набором виджетов и корневым элементом
    init(widgets: [WidgetInstanceId: Widget], rootId: WidgetInstanceId?) {
        self.widgets = widgets
        self.rootId = rootId
    }
}
