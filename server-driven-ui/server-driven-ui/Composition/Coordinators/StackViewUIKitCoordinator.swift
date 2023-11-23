//
//  StackViewUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias StackViewWidgetPositioning = (UIKitWidgetPositioningViewModel) -> Void
typealias StackViewWidgetUpdate = (WidgetData) -> Void
typealias StackViewWidgetFactory = (WidgetId, WidgetData) -> (
    WidgetStackView,
    StackViewWidgetUpdate,
    StackViewWidgetPositioning
)

final class StackViewUIKitCoordinator: UIKitWidgetCoordinator {
    private let factory: StackViewWidgetFactory
    private var stackView: WidgetStackView?
    private var performUpdate: StackViewWidgetUpdate?
    private var performPositioning: StackViewWidgetPositioning?
    
    init(factory: @escaping StackViewWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {
        let (stackView, update, positioning) = factory(viewModel.id, viewModel.data)
        self.stackView = stackView
        self.performUpdate = update
        self.performPositioning = positioning
    }
    
    func getView() -> UIView? {
        stackView
    }
    
    func update(with viewModel: UIKitWidgetUpdateViewModel) {
        performUpdate?(viewModel.data)
    }
    
    func position(with viewModel: UIKitWidgetPositioningViewModel) {
        performPositioning?(viewModel)
    }
}
