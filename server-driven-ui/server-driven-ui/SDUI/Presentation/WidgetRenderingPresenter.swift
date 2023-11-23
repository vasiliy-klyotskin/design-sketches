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
    
    func present(widgetDifference change: WidgetHeirarchyChange) {
        let viewModel = WidgetRenderingViewModel(
            creations: creations(for: change),
            deletions: deletions(for: change),
            updates: updates(for: change),
            positioning: positioning(for: change)
        )
        view.display(viewModel: viewModel)
    }
    
    private func creations(for change: WidgetHeirarchyChange) -> [WidgetRenderingViewModel.Creation] {
        change.newWidgets.map { .init(id: $0.id, data: $0.data) }
    }
    
    private func deletions(for change: WidgetHeirarchyChange) -> [WidgetRenderingViewModel.Deletion] {
        change.removedWidgets.map { .init(id: $0.id) }
    }
    
    private func updates(for change: WidgetHeirarchyChange) -> [WidgetRenderingViewModel.Update] {
        change.remainedWithTheSameInstanceIdWidgets
            .filter { $0.current.hasDifferentState(from: $0.previous) ?? false }
            .map { .init(id: $0.current.id, data: $0.current.data) }
    }
    
    private func positioning(for change: WidgetHeirarchyChange) -> [WidgetRenderingViewModel.Positioning] {
        positioningForNewContainers(change) + positioningForRemainedTheSameContainers(change)
    }
    
    private func positioningForNewContainers(_ change: WidgetHeirarchyChange) -> [WidgetRenderingViewModel.Positioning] {
        change.newContainers
           .map {
               WidgetRenderingViewModel.Positioning.init(
                   id: $0.id,
                   previous: nil,
                   current: .init(data: $0.positioning, children: $0.children)
               )
           }
    }
    
    private func positioningForRemainedTheSameContainers(_ change: WidgetHeirarchyChange) -> [WidgetRenderingViewModel.Positioning] {
        change.remainedWithTheSameInstanceIdContainers
            .filter { $0.current.hasDifferentPositioning(from: $0.previous) ?? false }
            .map {
                .init(
                    id: $0.current.id,
                    previous: .init(data: $0.previous.positioning, children: $0.previous.children),
                    current: .init(data: $0.current.positioning, children: $0.current.children)
                )
            }
    }
}
