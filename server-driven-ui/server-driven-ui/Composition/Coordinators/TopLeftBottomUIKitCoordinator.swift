//
//  TopLeftBottomUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias TopLeftBottomWidgetPositioning = (UIView?, Int) -> Void
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
    
    func loadView(for data: WidgetData, with id: WidgetId) {
        let (widget, update, positioning) = factory(id, data)
        self.topLeftBottomWidget = widget
        self.performUpdate = update
        self.performPositioning = positioning
    }
    
    func update(with data: WidgetData) {
        performUpdate?(data)
    }
    
    func insertChild(view: UIView, at index: Int) {
        performPositioning?(view, index)
    }
    
    func deleteChild(at index: Int) {
        performPositioning?(nil, index)
    }
    
    func useView(usage: (UIView) -> Void) {
        guard let topLeftBottomWidget else { return }
        usage(topLeftBottomWidget)
    }
}
