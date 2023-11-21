//
//  WidgetPresentationViewModels.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/16/23.
//

import Foundation

struct WidgetDifferenceViewModel {
    let deletions: WidgetDeletionsViewModel
    let insertions: WidgetInsertionsViewModel
    let updates: WidgetUpdatesViewModel
    
    var deletedAndNotInsertedChildrenInstanceIds: [WidgetInstanceId] {
        let deletedChildren = Set(deletions.map { $0.childId.instance })
        let insertedChildren = Set(insertions.map { $0.childId.instance })
        var result = deletedChildren
        result.subtract(insertedChildren)
        return Array(result)
    }
}

typealias WidgetDeletionsViewModel = [(childId: WidgetId, parentId: WidgetId, index: Int)]
typealias WidgetInsertionsViewModel = [(childId: WidgetId, parentId: WidgetId, index: Int, data: WidgetData)]
typealias WidgetUpdatesViewModel = [(id: WidgetId, data: WidgetData)]

extension WidgetDifference {
    func deletionsViewModel(from removals: [CollectionDifference<WidgetPair>.Change]) -> WidgetDeletionsViewModel {
        removals.compactMap {
            switch $0 {
            case .remove(_, let element, _):
                guard let child = old.widgets[element.child] else { return nil }
                guard let parent = old.widgets[element.parent] else { return nil }
                return (childId: child.id, parentId: parent.id, index: element.childIndexInParent)
            default: return nil
            }
        }
    }
    
    func insertionsViewModel(
        from insertions: [CollectionDifference<WidgetPair>.Change],
        heirarchy: WidgetHeirarchy
    ) -> WidgetInsertionsViewModel {
        insertions.compactMap {
            switch $0 {
            case .insert(_, let element, _):
                guard let child = new.widgets[element.child] else { return nil }
                guard let parent = new.widgets[element.parent] else { return nil }
                guard let data = heirarchy.widgets[element.child]?.data else { return nil }
                return (
                    childId: child.id,
                    parentId: parent.id,
                    index: element.childIndexInParent,
                    data: data
                )
            default: return nil
            }
        }
    }
}
