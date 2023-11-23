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
    
    /// Возвращает **true** если виджет, у которого вызывается этот метод и ``other`` отличаются только состоянием, имея при этом одинаковый идентификатор.
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
