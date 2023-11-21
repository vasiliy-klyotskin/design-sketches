//
//  WidgetPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import Foundation

protocol WidgetDifferenceView {
    func display(viewModel: WidgetDifferenceViewModel)
}

final class WidgetDifferencePresenter {
    private let view: WidgetDifferenceView
    
    init(view: WidgetDifferenceView) {
        self.view = view
    }
    
    func present(widgetDifference diff: WidgetDifference) {
        let (deletions, insertions) = deletionsAndInsertions(from: diff)
        let updates = updates(from: diff)
        view.display(viewModel: .init(
            deletions: deletions,
            insertions: insertions,
            updates: updates
        ))
    }

    private func deletionsAndInsertions(from diff: WidgetDifference) -> (WidgetDeletionsViewModel, WidgetInsertionsViewModel) {
        let oldPairs = diff.old.allPairsBreadthFirst
        let newPairs = diff.new.allPairsBreadthFirst
        let difference = newPairs.difference(from: oldPairs)
        let deletionsViewModel = diff.deletionsViewModel(from: difference.removals)
        let insertionsViewModel = diff.insertionsViewModel(from: difference.insertions, heirarchy: diff.new)
        return (deletionsViewModel, insertionsViewModel)
    }
    
    private func updates(from diff: WidgetDifference) -> WidgetUpdatesViewModel {
        diff.old.widgets.compactMap { (instanceId, oldWidget) in
            diff.new.widgets[instanceId].flatMap { newWidget in
                newWidget.isDifferentState(from: oldWidget) ? (newWidget.id, newWidget.data) : nil
            }
        }
    }
}
