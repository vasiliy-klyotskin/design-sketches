//
//  Widget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import Foundation

typealias WidgetTypeId = AnyHashable
typealias WidgetInstanceId = AnyHashable
typealias WidgetStateId = AnyHashable
typealias WidgetPositioningId = AnyHashable
typealias WidgetData = Data
typealias WidgetPositioning = Data

/// Унифицированная структура, представляющая виджет
///
/// Widget это унифицированная структура, содержащая информацию о виджете. Из экземпляров Widget состоит дерево виджетов, которое является основой для управления структурой всех составляющих SDUI экрана.
struct Widget {
    /// Идентификатор виджета
    ///
    /// Идентификатор содержит в себе информацию о типе виджета, его уникальный идентификатор и состояние. Подробнее см. в ``WidgetId``
    let id: WidgetId
    
    /// Идентификатор родительского виджета
    let parent: WidgetInstanceId
    
    /// Идентификаторы дочерних виджетов.
    ///
    /// Здесь хранятся не сами дочерние виджеты, а их идентификаторы. Это позволяет отделить структуру дерева виджетов от самих виджетов и хранить их отдельно, что дает гибкость модификации дерева.
    let children: [WidgetInstanceId]
    
    /// Данные виджета
    ///
    /// Данные представлены в виде **Swift.Data**. Это решает проблему динамической типизации. Для модификации дерева нам достаточно лишь сравнивать данные виджетов на равенство, не обращая внимание на тип, в котором хранятся эти данные.
    ///
    /// Десериализация данных происходит на этапе конфигурирования конкретного виджета, который знает в какой конкретный тип нужно их десериализовать.
    let data: WidgetData

    // TODO: Documentation
    let positioning: WidgetPositioning
        
    /// Действия, выполняемые при генерации виджетов событий
    ///
    /// Действие  - это некоторое заранее запрограммирование поведение. Действия прикрепляются к событиям виджетов и запускаются при наступлении этих событий.
    let actions: [Action]
    
    // TODO: Documentation
    var isContainer: Bool {
        id.positioning != WidgetId.positioningIdForNotContainers
    }
    
    /// Возвращает **true** если виджет, у которого вызывается этот метод и ``other`` отличаются только состоянием, имея при этом одинаковыц тип и идентификатор.
    /// - Parameter from: Виджет, с которым нужно провести сравнение.
    func hasDifferentState(from other: Widget) -> Bool? {
        guard id.instance == other.id.instance else { return nil }
        return id.state != other.id.state
    }
    
    // TODO: Documentation
    func hasDifferentPositioning(from other: Widget) -> Bool? {
        guard id.instance == other.id.instance else { return nil }
        return id.positioning != other.id.positioning
    }
    
    /// Возвращает копию виджета, заменяя некоторые его данные
    ///
    /// Используется для создания копии виджета с опциональной заменой parent, data или children
    /// - Parameters:
    ///   - parent: Если передается значение не nil, то в копии свойству parent будет присвоено переданное значение
    ///   - data: Если передается значение не nil, то в копии свойству data будет присвоено переданное значение
    ///   - children: Если передается значение не nil, то в копии свойству children будет присвоено переданное значение
    func copyWith(
        parent: WidgetInstanceId? = nil,
        data: WidgetData? = nil,
        children: [WidgetInstanceId]? = nil
    ) -> Widget {
        .init(
            id: id,
            parent: parent ?? self.parent,
            children: children ?? self.children,
            data: data ?? self.data,
            positioning: positioning,
            actions: actions
        )
    }
}


/// Идентификатор виджета
///
/// Содержит информацию и типе, уникальный идентификатор виджета и идентификатор его состояния.
/// Используется как ключ в хэш таблицах и как идентификатор для построения разницы виджет-деревьев.
struct WidgetId {
    /// Идентификатор типа виджета. Чаще всего это просто строка
    let type: WidgetTypeId
    /// Идентификатор экземпляра виджета. Чаще всего это просто строка
    let instance: WidgetInstanceId
    
    // TODO: Marina А это свойство используется?
    /// Идентификатор состояния виджета
    let state: WidgetStateId
    
    // TODO: Documentation
    let positioning: WidgetPositioningId
    
    // TODO: Documentation
    static var positioningIdForNotContainers: WidgetPositioningId {
        "NO_POSITIONING"
    }
    
    // TODO: Documentation
    static var rootContainerKeyForIds: String {
        "ROOT_CONTAINER"
    }
}

// TODO: Marina Кажется, слово Difference тут не очень подходит, поскольку здесь не содержится самой разницы, может, заменить на  Pair? WidgetDifference -> WidgetHierarchyPair
/// Структура, хранящая две иерархии виджетов - "предыдущую" и "текущую"
struct WidgetDifference {
    // TODO: Rename: Previous, current
    let new: WidgetHeirarchy
    let old: WidgetHeirarchy
    
    /// Виджеты, которые не содержатся в предыдущей иерархии, но содержаться в текущей
    var newWidgets: [Widget] {
        new.allInstanceIds.subtracting(old.allInstanceIds).compactMap { new.widgets[$0] }
    }
    
    /// Виджеты, которые не содержатся в текущей иерархии, но содержаться в предыдущей
    var removedWidgets: [Widget] {
        old.allInstanceIds.subtracting(new.allInstanceIds).compactMap { old.widgets[$0] }
    }
    
    /// Виджеты, идентификаторы которых содержатся в текущей и предыдущей иерархиях
    var remainedWithTheSameInstanceIdWidgets: [(previous: Widget, current: Widget)] {
        new.allInstanceIds
            .intersection(old.allInstanceIds)
            .compactMap {
                guard let previous = old.widgets[$0] else { return nil }
                guard let current = new.widgets[$0] else { return nil }
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
