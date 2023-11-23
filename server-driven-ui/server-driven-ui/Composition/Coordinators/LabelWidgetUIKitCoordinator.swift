//
//  LabelWidgetUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias LabelWidgetUpdate = (WidgetData) -> Void
typealias LabelWidgetFactory = (WidgetId, WidgetData) -> (LabelWidget, LabelWidgetUpdate)

final class LabelUIKitCoordinator: UIKitWidgetCoordinator {
    private var label: LabelWidget?
    private var performUpdate: LabelWidgetUpdate?
    private let factory: LabelWidgetFactory
    
    init(factory: @escaping LabelWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for viewModel: UIKitWidgetCreationViewModel) {
        let (label, performUpdate) = factory(viewModel.id, viewModel.data)
        self.label = label
        self.performUpdate = performUpdate
    }
    
    func getView() -> UIView? {
        label
    }
    
    func update(with viewModel: UIKitWidgetUpdateViewModel) {
        performUpdate?(viewModel.data)
    }
}
