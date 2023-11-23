//
//  ButtonUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias ButtonWidgetUpdate = (WidgetData) -> Void
typealias ButtonWidgetFactory = (WidgetId, WidgetData) -> (ButtonWidget, ButtonWidgetUpdate)

final class ButtonUIKitCoordinator: UIKitWidgetCoordinator {
    private var button: ButtonWidget?
    private var performUpdate: ButtonWidgetUpdate?
    private let factory: ButtonWidgetFactory
    
    init(factory: @escaping ButtonWidgetFactory) {
        self.factory = factory
    }
    
    func getView() -> UIView? {
        button
    }
    
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {
        let (button, performUpdate) = factory(viewModel.id, viewModel.data)
        self.button = button
        self.performUpdate = performUpdate
    }
    
    func update(with viewModel: UIKitWidgetUpdateViewModel) {
        performUpdate?(viewModel.data)
    }
}
