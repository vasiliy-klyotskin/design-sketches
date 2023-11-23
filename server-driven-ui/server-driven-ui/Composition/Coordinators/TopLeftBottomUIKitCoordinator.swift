//
//  TopLeftBottomUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias TopLeftBottomWidgetPositioning = (UIKitWidgetPositioningViewModel) -> Void
typealias TopLeftBottomWidgetUpdate = (WidgetData) -> Void
typealias TopLeftBottomWidgetFactory = (WidgetId, WidgetData) -> (
    TopLeftBottomWidget,
    TopLeftBottomWidgetUpdate,
    TopLeftBottomWidgetPositioning
)

final class TopLeftBottomUIKitCoordinator: UIKitWidgetCoordinator {
    private var topLeftBottomWidget: TopLeftBottomWidget?
    private var performUpdate: TopLeftBottomWidgetUpdate?
    private var performPositioning: TopLeftBottomWidgetPositioning?
    private let factory: TopLeftBottomWidgetFactory
    
    init(factory: @escaping TopLeftBottomWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {
        let (widget, update, positioning) = factory(viewModel.id, viewModel.data)
        self.topLeftBottomWidget = widget
        self.performUpdate = update
        self.performPositioning = positioning
    }
    
    func getView() -> UIView? {
        topLeftBottomWidget
    }
    
    func update(with viewModel: UIKitWidgetUpdateViewModel) {
        performUpdate?(viewModel.data)
    }
    
    func position(with viewModel: UIKitWidgetPositioningViewModel) {
        performPositioning?(viewModel)
    }
}
