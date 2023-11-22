//
//  UIKitWidgetCoordinatorRegistry.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

typealias UIKitCoordinatorFactory = (WidgetTypeId) -> UIKitWidgetCoordinator

protocol UIKitWidgetCoordinator {
    func loadView(for data: WidgetData, with id: WidgetId)
    func update(with data: WidgetData)
    func useView(usage: (UIView) -> Void)
    func insertChild(view: UIView, at index: Int)
    func deleteChild(at index: Int)
}

final class UIKitWidgetCoordinatorRegistry: WidgetDifferenceView {
    private let coordinatorFactory: UIKitCoordinatorFactory
    private var widgetCoordinators: [WidgetInstanceId: UIKitWidgetCoordinator] = [:]
    
    init(_ coordinatorFactory: @escaping UIKitCoordinatorFactory) {
        self.coordinatorFactory = coordinatorFactory
    }
    
    func display(viewModel: WidgetDifferenceViewModel) {
        viewModel.deletions.forEach(delete)
        viewModel.insertions.forEach(insert)
        viewModel.updates.forEach(update)
        viewModel.deletedAndNotInsertedChildrenInstanceIds.forEach(release)
    }
    
    private func insert(
        child childId: WidgetId,
        toParent parentId: WidgetId,
        at index: Int,
        data: WidgetData
    ) {
        let needToLoad = widgetCoordinators[childId.instance] == nil
        let parentCoordinator = widgetCoordinators[parentId.instance] ?? coordinatorFactory(parentId.type)
        let childCoordinator = widgetCoordinators[childId.instance] ?? coordinatorFactory(childId.type)
        if needToLoad {
            childCoordinator.loadView(for: data, with: childId)
        }
        childCoordinator.useView {
            parentCoordinator.insertChild(view: $0, at: index)
        }
        widgetCoordinators[childId.instance] = childCoordinator
        widgetCoordinators[parentId.instance] = parentCoordinator
    }
    
    private func delete(child childId: WidgetId, fromParent parentId: WidgetId, at index: Int) {
        widgetCoordinators[parentId.instance]?.deleteChild(at: index)
    }
    
    private func release(for id: WidgetInstanceId) {
        widgetCoordinators[id] = nil
    }
    
    private func update(id: WidgetId, data: WidgetData) {
        widgetCoordinators[id.instance]?.update(with: data)
    }
}

extension UIKitWidgetCoordinator {
    func insertChild(view: UIView, at index: Int) {}
    func deleteChild(at index: Int) {}
    func loadView(for data: WidgetData, with id: WidgetId) {}
    func update(with data: WidgetData) {}
    func useView(usage: (UIView) -> Void) {}
}
