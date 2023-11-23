//
//  WidgetRenderingPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import Foundation

protocol WidgetRenderingView {
    func display(viewModel: WidgetRenderingViewModel)
}

final class WidgetRenderingPresenter {
    private let view: WidgetRenderingView
    
    init(view: WidgetRenderingView) {
        self.view = view
    }
    
    func present(widgetDifference diff: WidgetDifference) {
        let viewModel = WidgetRenderingViewModel(
            creations: creations(for: diff),
            deletions: deletions(for: diff),
            updates: updates(for: diff),
            positioning: positioning(for: diff)
        )
        view.display(viewModel: viewModel)
    }
    
    private func creations(for diff: WidgetDifference) -> [WidgetRenderingViewModel.Creation] {
        diff.newWidgets.map { .init(id: $0.id, data: $0.data) }
    }
    
    private func deletions(for diff: WidgetDifference) -> [WidgetRenderingViewModel.Deletion] {
        diff.removedWidgets.map { .init(id: $0.id) }
    }
    
    private func updates(for diff: WidgetDifference) -> [WidgetRenderingViewModel.Update] {
        diff.remainedWithTheSameInstanceIdWidgets
            .filter { $0.current.hasDifferentState(from: $0.previous) ?? false }
            .map { .init(id: $0.current.id, data: $0.current.data) }
    }
    
    private func positioning(for diff: WidgetDifference) -> [WidgetRenderingViewModel.Positioning] {
        let positioningForNewContainers = diff.newContainers
            .map {
                WidgetRenderingViewModel.Positioning.init(
                    id: $0.id,
                    positioningChanges: .init(
                        old: nil,
                        new: .init(positioning: $0.positioning, children: $0.children)
                    )
                )
            }
        
        let positioningForRemainedTheSameContainers = diff.remainedWithTheSameInstanceIdContainers
            .filter { $0.current.hasDifferentPositioning(from: $0.previous) ?? false }
            .map {
                WidgetRenderingViewModel.Positioning.init(
                    id: $0.current.id,
                    positioningChanges: .init(
                        old: .init(positioning: $0.previous.positioning, children: $0.previous.children),
                        new: .init(positioning: $0.current.positioning, children: $0.current.children)
                    )
                )
            }
        return positioningForNewContainers + positioningForRemainedTheSameContainers
    }
}
