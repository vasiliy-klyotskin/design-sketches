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
typealias WidgetData = Data

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
    
    /// Действия, выполняемые при генерации виджетов событий
    ///
    /// Действие  - это некоторое заранее запрограммирование поведение. Действия прикрепляются к событиям виджетов и запускаются при наступлении этих событий.
    let actions: [Action]
    
    /// Возвращает **true** если виджет, у которого вызывается этот метод и ``other`` отличаются только состоянием, имея при этом одинаковыц тип и идентификатор.
    /// - Parameter from: Виджет, с которым нужно провести сравнение.
    func isDifferentState(from other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance == other.id.instance &&
        id.state != other.id.state
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
}

// TODO: Marina Кажется, слово Difference тут не очень подходит, поскольку здесь не содержится самой разницы, может, заменить на  Pair? WidgetDifference -> WidgetHierarchyPair
/// Структура, хранящая две иерархии виджетов - "старую" и "новую"
struct WidgetDifference {
    let new: WidgetHeirarchy
    let old: WidgetHeirarchy
}

/// Иерархия виджетов
///
/// Поскольку информация о родительских и дочерних виджетах хранится в ``Widget``, способ хранения выбран самый простой: в виде хэш таблицы
struct WidgetHeirarchy {
    /// Виджеты
    let widgets: [WidgetInstanceId: Widget]
    
    /// Идентификатор корневого виджета дерева
    let rootId: WidgetInstanceId?
    
    /// Возвращает список виджетов из ``widgets`` в виде несортированного массива
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    /// Возвращает корневой виджет, если он есть
    var root: Widget? {
        rootId.flatMap { widgets[$0] }
    }
    
    /// Проецирует ``widgets`` в массив ``WidgetPair`` выполняя послойный обход дерева
    ///
    /// Послойный обход выполняется так:
    /// - сначала в массив помещается корень дерева
    /// - затем в массив помещаются дочерние элементы корня в том порядке, в котором их идентификаторы хранятся в ``Widget/children``
    /// - выполняется рекурсивно до тех пор пока не будут пройдены все слои дерева
    var allPairsBreadthFirst: [WidgetPair] {
        var result: [WidgetPair] = []
        var queue: [(offset: Int, element: Widget)] = root.map { [(0, $0)] } ?? []
        
        while let (index, widget) = queue.first {
            queue.removeFirst()
            result.append(.withParent(widget, indexInParent: index))
            queue.append(contentsOf: widget.children.compactMap { widgets[$0] }.enumerated())
        }
        return result
    }
    
    
    /// Возвращает новое дерево виджетов, в котором текущее дерево помещается под новый корневой элемент с идентификатором "ROOT_CONTAINER"
    var wrappedIntoRootContainer: WidgetHeirarchy {
        let idKey = "ROOT_CONTAINER"
        let rootContainer = Widget(
            id: .init(type: idKey, instance: idKey, state: idKey),
            parent: idKey,
            children: [rootId].compactMap { $0 },
            data: .init(),
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

/// Структура, содержащая информацию о местоположении виджета в дереве
struct WidgetPair: Equatable {
    /// Идентификатор родителя
    let parent: WidgetInstanceId
    /// Идентификатор виджета
    let child: WidgetInstanceId
    /// Порядковый номер виджета в списке детей у ``parent``
    let childIndexInParent: Int
    
    /// Возвращает ``WidgetPair`` в которой идентификаторы родительского и дочернего элементов берутся из **widget**, а порядковый номер из **indexInParent**
    static func withParent(_ widget: Widget, indexInParent: Int) -> WidgetPair {
        .init(parent: widget.parent, child: widget.id.instance, childIndexInParent: indexInParent)
    }
}
