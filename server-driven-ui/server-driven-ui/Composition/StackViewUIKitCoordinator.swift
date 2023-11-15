//
//  StackViewUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

final class StackViewUIKitCoordinator: UIKitWidgetCoordinator {
    private let factory: (WidgetStackModel) -> WidgetStackView
    private let getModel: (WidgetId) -> WidgetStackModel
    
    init(
        factory: @escaping (WidgetStackModel) -> WidgetStackView,
        getModel: @escaping (WidgetId) -> WidgetStackModel
    ) {
        self.factory = factory
        self.getModel = getModel
    }
    
    private var stackView: WidgetStackView?
    
    func getView(id: WidgetId) -> UIView {
        if let stackView {
            return stackView
        } else {
            let stackView = factory(getModel(id))
            self.stackView = stackView
            return stackView
        }
    }
    
    func update(id: WidgetId) {
        stackView?.update(model: getModel(id))
    }
    
    func insertChild(view: UIView, at index: Int) {
        stackView?.insert(view: view, at: index)
    }
    
    func deleteChild(at index: Int) {
        stackView?.delete(at: index)
    }
}

// виджет и модель

struct WidgetStackModel {}
final class WidgetStackView: UIView {
    func update(model: WidgetStackModel) {}
    func insert(view: UIView, at index: Int) {}
    func delete(at index: Int) {}
}
