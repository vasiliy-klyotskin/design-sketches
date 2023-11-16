//
//  WidgetPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import Foundation

final class WidgetDifferencePresenter {
    static func present(widgetDifference diff: WidgetDifference) -> WidgetDifferenceViewModel {
        let (deletions, insertions) = deletionsAndInsertions(from: diff)
        let updates = updates(from: diff)
        return .init(deletions: deletions, insertions: insertions, updates: updates)
    }

    private static func deletionsAndInsertions(from diff: WidgetDifference) -> (WidgetDeletionsViewModel, WidgetInsertionsViewModel) {
        let oldPairs = diff.old.allPairsBreadthFirst
        let newPairs = diff.new.allPairsBreadthFirst
        let difference = newPairs.difference(from: oldPairs)
        let deletionsViewModel = diff.deletionsViewModel(from: difference.removals)
        let insertionsViewModel = diff.insertionsViewModel(from: difference.insertions)
        return (deletionsViewModel, insertionsViewModel)
    }
    
    private static func updates(from diff: WidgetDifference) -> WidgetUpdatesViewModel {
        diff.old.widgets.compactMap { (instanceId, oldWidget) in
            diff.new.widgets[instanceId].flatMap { newWidget in
                newWidget.isDifferentState(from: oldWidget) ? newWidget.id : nil
            }
        }
    }
}
