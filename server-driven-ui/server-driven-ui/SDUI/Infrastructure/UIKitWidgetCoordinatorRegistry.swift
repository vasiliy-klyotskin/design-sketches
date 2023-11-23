//
//  UIKitWidgetCoordinatorRegistry.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

typealias UIKitCoordinatorFactory = (WidgetTypeId) -> UIKitWidgetCoordinator

// TODO: Marina Может, тут лучше использовать привычное слово presenter или controller?
protocol UIKitWidgetCoordinator {
    /// Реализация этого метода должна загрузить View виджета, сконфигурировать его  переданными данными и запомнить ссылку на него.
    ///
    /// Дефолтная реализация ничего не делает
    func loadView(for data: WidgetData, with id: WidgetId)
    
    /// Реализация этого метода должна обновить виджет переданными данными
    ///
    /// Дефолтная реализация ничего не делает
    func update(with data: WidgetData)
    
    /// Реализация этого метода должна синхронно выполнить замыкание usage, передав в него View виджета.
    ///
    /// Этот метод используется механизмом изменения иерархии виджетов на экране для того чтобы вставить View дочернего виджета в родительский не имея информации о его конкретном типе.
    ///
    /// Дефолтная реализация ничего не делает
    func useView(usage: (UIView) -> Void)
    
    /// Реализация этого метода должна вставлять дочернюю View по указанному индексу
    ///
    /// Дефолтная реализация ничего не делает
    func insertChild(view: UIView, at index: Int)

    /// Реализация этого метода должна удалять дочернюю View по указанному индексу
    ///
    /// Дефолтная реализация ничего не делает
    func deleteChild(at index: Int)
}

/// UIKit реализация механизма изменения иерархии виджетов на экране
///
/// UIKitWidgetCoordinatorRegistry выполняет две функции:
/// - хранит хэш таблицу, связывающую идентификатор виджета и соответствующий ему координатор виджета (``UIKitWidgetCoordinator``)
/// - выполняет удаление, вставку и обновление вьюх на экране через координаторы
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
