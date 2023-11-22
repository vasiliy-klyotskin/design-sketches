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

struct Widget {
    let id: WidgetId
    let parent: WidgetInstanceId
    let children: [WidgetInstanceId]
    let data: WidgetData
    let actions: [Action]
    
    func isDifferentState(from other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance == other.id.instance &&
        id.state != other.id.state
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
            actions: actions
        )
    }
}

struct WidgetId {
    let type: WidgetTypeId
    let instance: WidgetInstanceId
    let state: WidgetStateId
}

struct WidgetDifference {
    let new: WidgetHeirarchy
    let old: WidgetHeirarchy
}

struct WidgetHeirarchy {
    let widgets: [WidgetInstanceId: Widget]
    let rootId: WidgetInstanceId?
    
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    var root: Widget? {
        rootId.flatMap { widgets[$0] }
    }
    
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
    
    static var empty: WidgetHeirarchy {
        .init(widgets: [:], rootId: nil)
    }
    
    init(widgets: [WidgetInstanceId: Widget], rootId: WidgetInstanceId?) {
        self.widgets = widgets
        self.rootId = rootId
    }
}

struct WidgetPair: Equatable {
    let parent: WidgetInstanceId
    let child: WidgetInstanceId
    let childIndexInParent: Int
    
    static func withParent(_ widget: Widget, indexInParent: Int) -> WidgetPair {
        .init(parent: widget.parent, child: widget.id.instance, childIndexInParent: indexInParent)
    }
}
