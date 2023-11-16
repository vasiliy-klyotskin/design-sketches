//
//  UIKitWidgetCoordinatorRegistry.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

final class UIKitWidgetCoordinatorRegistry {
    var coordinatorFactory: (WidgetTypeId) -> UIKitWidgetCoordinator
    var widgetCoordinators: [WidgetInstanceId: UIKitWidgetCoordinator] = [:]
    
    init(coordinatorFactory: @escaping (WidgetTypeId) -> UIKitWidgetCoordinator) {
        self.coordinatorFactory = coordinatorFactory
    }
    
    func coordinate(viewModel: WidgetDifferenceViewModel) {
        viewModel.deletions.forEach(delete)
        viewModel.insertions.forEach(insert)
        viewModel.updates.forEach(update)
        viewModel.deletedAndNotInsertedChildrenInstanceIds.forEach(release)
    }
    
    private func insert(child childId: WidgetId, toParent parentId: WidgetId, at index: Int) {
        let parentCoordinator = widgetCoordinators[parentId.instance] ?? coordinatorFactory(parentId.type)
        let childCoordinator = widgetCoordinators[childId.instance] ?? coordinatorFactory(childId.type)
        
        let child = childCoordinator.getView(id: childId)
        parentCoordinator.insertChild(view: child, at: index)
        
        widgetCoordinators[childId.instance] = childCoordinator
        widgetCoordinators[parentId.instance] = parentCoordinator
    }
    
    private func delete(child childId: WidgetId, fromParent parentId: WidgetId, at index: Int) {
        widgetCoordinators[parentId.instance]?.deleteChild(at: index)
        
    }
    
    private func release(for id: WidgetInstanceId) {
        widgetCoordinators[id] = nil
    }
    
    private func update(id: WidgetId) {
        widgetCoordinators[id.instance]?.update(id: id)
    }
}

protocol UIKitWidgetCoordinator {
    func getView(id: WidgetId) -> UIView
    func update(id: WidgetId)
    func insertChild(view: UIView, at index: Int)
    func deleteChild(at index: Int)
}

extension UIKitWidgetCoordinator {
    func insertChild(view: UIView, at index: Int) {}
    func deleteChild(at index: Int) {}
}
