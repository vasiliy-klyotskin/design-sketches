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

struct WidgetId {
    let type: WidgetTypeId
    let instance: WidgetInstanceId
    let state: WidgetStateId
}

struct Widget {
    let id: WidgetId
    let parent: WidgetInstanceId
    let children: [WidgetInstanceId]
    
    func isDifferentType(from other: Widget) -> Bool {
        id.type != other.id.type
    }
    
    func isDifferentInstance(from other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance != other.id.instance
    }
    
    func isDifferentState(from other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance == other.id.instance &&
        id.state != other.id.state
    }
    
    func hasTheSameIdentity(as other: Widget) -> Bool {
        id.type == other.id.type &&
        id.instance == other.id.instance &&
        id.state == other.id.state
    }
}

struct WidgetHeirarchy {
    let widgets: [WidgetInstanceId: Widget]
    
    let root: Widget
    
    var allWidgets: [Widget] {
        Array(widgets.values)
    }
    
    init(widgets: [WidgetInstanceId: Widget], rootId: WidgetInstanceId?) {
        var widgets = widgets
        root = .init(id: .init(type: "root", instance: "root", state: "root"), parent: "root", children: [rootId].compactMap {$0})
        widgets["root"] = root
        self.widgets = widgets
    }
    
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

struct WidgetDifference {
    let new: WidgetHeirarchy
    let old: WidgetHeirarchy
}

struct WidgetPair: Equatable {
    let parent: WidgetInstanceId
    let child: WidgetInstanceId
    let childIndexInParent: Int
    
    static func withParent(_ widget: Widget, indexInParent: Int) -> WidgetPair {
        .init(parent: widget.parent, child: widget.id.instance, childIndexInParent: indexInParent)
    }
}
