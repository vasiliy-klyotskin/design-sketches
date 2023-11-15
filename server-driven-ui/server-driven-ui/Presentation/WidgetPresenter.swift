//
//  WidgetPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//



// Presentation

import Foundation

struct WidgetDifferenceViewModel {
    let deletions: [(childId: WidgetId, parentId: WidgetId, index: Int)]
    let insertions: [(childId: WidgetId, parentId: WidgetId, index: Int)]
    let updates: [WidgetId]
}

protocol WidgetDifferencePresenterDelegate {
    func coordinate(viewModel: WidgetDifferenceViewModel)
}

final class WidgetDifferencePresenter {
    let delegate: WidgetDifferencePresenterDelegate
    
    init(delegate: WidgetDifferencePresenterDelegate) {
        self.delegate = delegate
    }
    
    func present(widgetDifference diff: WidgetDifference) {
        // Рекурсивно посчитать вьюмодель дифф и вызвать метод делегата c расчитанной вьюмоделью
        calculate(diff: diff)
        delegate.coordinate(viewModel: <#T##WidgetDifferenceViewModel#>)
    }
    
    func calculate(diff: WidgetDifference) {
        if diff.widgetsHaveTheSameIdentity {
            
        } else if diff.widgetsAreWithDifferentState {
            
        } else if diff.widgetsAreWithDifferentInstance {

        } else if diff.widgetsAreWithDifferentType {

        }
    }
}
