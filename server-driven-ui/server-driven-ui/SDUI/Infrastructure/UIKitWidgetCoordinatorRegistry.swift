//
//  UIKitWidgetCoordinatorRegistry.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

typealias UIKitCoordinatorFactory = (WidgetTypeId) -> UIKitWidgetCoordinator

/// UIKit реализация механизма изменения иерархии виджетов на экране
///
/// UIKitWidgetCoordinatorRegistry выполняет две функции:
/// - хранит хэш таблицу, связывающую идентификатор виджета и соответствующий ему координатор виджета (``UIKitWidgetCoordinator``)
/// - выполняет удаление, вставку и обновление вьюх на экране через координаторы
final class UIKitWidgetCoordinatorRegistry: WidgetRenderingView {
    private let factory: UIKitCoordinatorFactory
    private var widgetCoordinators: [WidgetInstanceId: UIKitWidgetCoordinator] = [:]
    
    init(_ coordinatorFactory: @escaping UIKitCoordinatorFactory) {
        self.factory = coordinatorFactory
    }
    
    func display(viewModel: WidgetRenderingViewModel) {
        viewModel.deletions.forEach(delete)
        viewModel.creations.forEach(create)
        viewModel.updates.forEach(update)
        viewModel.positioning.forEach(position)
    }
    
    private func delete(for viewModel: WidgetRenderingViewModel.Deletion) {
        widgetCoordinators[viewModel.id.instance] = nil
    }
    
    private func create(for viewModel: WidgetRenderingViewModel.Creation) {
        let coordinator = factory(viewModel.id.type)
        coordinator.loadView(for: .init(id: viewModel.id, data: viewModel.data))
        widgetCoordinators[viewModel.id.instance] = coordinator
    }
    
    private func update(for viewModel: WidgetRenderingViewModel.Update) {
        guard let node = widgetCoordinators[viewModel.id.instance] else { return }
        node.update(with: .init(data: viewModel.data))
    }
    
    private func position(for viewModel: WidgetRenderingViewModel.Positioning) {
        guard let node = widgetCoordinators[viewModel.id.instance] else { return }
        let childrenIds = viewModel.positioningChanges.new.children
        let childrenViews = childrenIds.compactMap { widgetCoordinators[$0]?.getView() }
        let zippedChildren = zip(childrenIds, childrenViews)
        let children = Dictionary(uniqueKeysWithValues: zippedChildren)
        node.position(with: .init(positioningChanges: viewModel.positioningChanges, children: children))
    }
}
