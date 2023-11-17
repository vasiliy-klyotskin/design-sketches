//
//  WidgetDifference.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import Foundation

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
        root = .init(id: .init(type: "ROOT", instance: "ROOT", state: "ROOT"), parent: "ROOT", children: [rootId].compactMap {$0})
        widgets["ROOT"] = root
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
