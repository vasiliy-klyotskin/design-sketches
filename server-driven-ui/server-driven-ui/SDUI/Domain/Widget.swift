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

struct Widget {
    let id: WidgetId
    let parent: WidgetInstanceId
    let children: [WidgetInstanceId]
    let data: WidgetData
    let positioning: WidgetPositioning
    let actions: [Action]
    
    var isContainer: Bool {
        id.positioning != WidgetId.positioningIdForNotContainers
    }
    
    func hasDifferentState(from other: Widget) -> Bool? {
        guard id.instance == other.id.instance else { return nil }
        return id.state != other.id.state
    }
    
    func hasDifferentPositioning(from other: Widget) -> Bool? {
        guard id.instance == other.id.instance else { return nil }
        return id.positioning != other.id.positioning
    }
    
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

struct WidgetId: Hashable {
    let type: WidgetTypeId
    let instance: WidgetInstanceId
    let state: WidgetStateId
    let positioning: WidgetPositioningId
    
    static var positioningIdForNotContainers: WidgetPositioningId {
        "NO_POSITIONING"
    }
    
    static var rootContainerKeyForIds: String {
        "ROOT_CONTAINER"
    }
}

struct WidgetDifference {
    // TODO: Rename: Previous, current
    let new: WidgetHeirarchy
    let old: WidgetHeirarchy
    
    var newWidgets: [Widget] {
        new.allInstanceIds.subtracting(old.allInstanceIds).compactMap { new.widgets[$0] }
    }
    
    var removedWidgets: [Widget] {
        old.allInstanceIds.subtracting(new.allInstanceIds).compactMap { old.widgets[$0] }
    }
    
    var remainedWithTheSameInstanceIdWidgets: [(previous: Widget, current: Widget)] {
        new.allInstanceIds
            .intersection(old.allInstanceIds)
            .compactMap {
                guard let previous = old.widgets[$0] else { return nil }
                guard let current = new.widgets[$0] else { return nil }
                return (previous, current)
            }
    }
    
    var newContainers: [Widget] {
        newWidgets.filter { $0.isContainer }
    }
    
    var remainedWithTheSameInstanceIdContainers: [(previous: Widget, current: Widget)] {
        remainedWithTheSameInstanceIdWidgets.filter { $0.current.isContainer }
    }
}

struct WidgetHeirarchy {
    let widgets: [WidgetInstanceId: Widget]
    let rootId: WidgetInstanceId?
    
    var allInstanceIds: Set<WidgetInstanceId> {
        Set(widgets.keys)
    }
    
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    var root: Widget? {
        rootId.flatMap { widgets[$0] }
    }
    
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
    
    static var empty: WidgetHeirarchy {
        .init(widgets: [:], rootId: nil)
    }
    
    init(widgets: [WidgetInstanceId: Widget], rootId: WidgetInstanceId?) {
        self.widgets = widgets
        self.rootId = rootId
    }
}
