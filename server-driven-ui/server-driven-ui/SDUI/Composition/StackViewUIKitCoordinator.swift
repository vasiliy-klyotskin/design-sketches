//
//  StackViewUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

final class StackViewUIKitCoordinator: UIKitWidgetCoordinator {
    private let factory: (WidgetStackModel, WidgetId) -> WidgetStackView
    private let getModel: (WidgetId) -> WidgetStackModel
    
    init(
        factory: @escaping (WidgetStackModel, WidgetId) -> WidgetStackView,
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
            let stackView = factory(getModel(id), id)
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
