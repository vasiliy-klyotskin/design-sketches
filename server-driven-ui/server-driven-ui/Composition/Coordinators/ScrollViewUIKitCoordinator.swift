//
//  ScrollViewUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias ScrollViewWidgetPositioning = (UIKitWidgetPositioningViewModel) -> Void
typealias ScrollViewWidgetUpdate = (WidgetData) -> Void
typealias ScrollViewWidgetFactory = (WidgetId, WidgetData) -> (WidgetScrollView, ScrollViewWidgetUpdate, ScrollViewWidgetPositioning)

final class ScrollViewUIKitCoordinator: UIKitWidgetCoordinator {
    private let factory: ScrollViewWidgetFactory
    private var scrollView: WidgetScrollView?
    private var performUpdate: ScrollViewWidgetUpdate?
    private var performPositioning: ScrollViewWidgetPositioning?

    init(factory: @escaping ScrollViewWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {
        let (scrollView, update, positioning) = factory(viewModel.id, viewModel.data)
        self.scrollView = scrollView
        self.performUpdate = update
        self.performPositioning = positioning
    }
    
    func update(with viewModel: UIKitWidgetUpdateViewModel) {
        performUpdate?(viewModel.data)
    }
    
    func getView() -> UIView? {
        scrollView
    }

    func position(with viewModel: UIKitWidgetPositioningViewModel) {
        performPositioning?(viewModel)
    }
}
