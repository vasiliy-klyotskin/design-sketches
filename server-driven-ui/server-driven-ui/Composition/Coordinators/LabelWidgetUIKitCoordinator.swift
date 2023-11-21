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
    
    func loadView(for data: WidgetData, with id: WidgetId) {
        let (label, performUpdate) = factory(id, data)
        self.label = label
        self.performUpdate = performUpdate
    }
    
    func update(with data: WidgetData) {
        performUpdate?(data)
    }
    
    func useView(usage: (UIView) -> Void) {
        guard let label else { return }
        usage(label)
    }
}
