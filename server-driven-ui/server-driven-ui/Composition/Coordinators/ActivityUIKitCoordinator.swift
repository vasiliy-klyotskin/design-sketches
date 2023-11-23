//
//  ActivityUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias ActivityWidgetUpdate = (WidgetData) -> Void
typealias ActivityWidgetFactory = (WidgetId, WidgetData) -> (ActivityWidget, ActivityWidgetUpdate)

final class ActivityUIKitCoordinator: UIKitWidgetCoordinator {
    private var activity: ActivityWidget?
    private var performUpdate: ActivityWidgetUpdate?
    private let factory: ActivityWidgetFactory
    
    init(factory: @escaping ActivityWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {
        let (activity, performUpdate) = factory(viewModel.id, viewModel.data)
        self.activity = activity
        self.performUpdate = performUpdate
    }
    
    func getView() -> UIView? {
        activity
    }
    
    func update(with viewModel: UIKitWidgetUpdateViewModel) {
        performUpdate?(viewModel.data)
    }
}
