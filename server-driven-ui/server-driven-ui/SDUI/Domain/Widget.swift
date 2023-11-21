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
    
    func with(new data: WidgetData) -> Widget {
        .init(id: id, parent: parent, children: children, data: data, actions: actions)
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
    let root: Widget
    
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    init(widgets: [WidgetInstanceId: Widget], rootId: WidgetInstanceId?) {
        var widgets = widgets
        root = .init(
            id: .init(
                type: Self.rootKey,
                instance: Self.rootKey,
                state: Self.rootKey
            ),
            parent: Self.rootKey,
            children: [rootId].compactMap {$0},
            data: Data(),
            actions: []
        )
        widgets[Self.rootKey] = root
        self.widgets = widgets
    }
    
    init?(rootedWidgets: [WidgetInstanceId: Widget]) {
        self.widgets = rootedWidgets
        self.root = rootedWidgets[Self.rootKey]!
    }
    
    private static var rootKey = "ROOT"
    
    static var empty: WidgetHeirarchy {
        .init(widgets: [:], rootId: nil)
    }
    
    var allPairsBreadthFirst: [WidgetPair] {
        var result: [WidgetPair] = []
        var queue: [(offset: Int, element: Widget)] = [(0, root)]
        
        while let (index, widget) = queue.first {
            queue.removeFirst()
            result.append(.withParent(widget, indexInParent: index))
            queue.append(contentsOf: widget.children.compactMap { widgets[$0] }.enumerated())
        }
        return result
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
