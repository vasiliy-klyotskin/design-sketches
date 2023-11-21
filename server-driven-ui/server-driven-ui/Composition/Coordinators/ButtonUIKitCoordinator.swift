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
    
    func loadView(for data: WidgetData, with id: WidgetId) {
        let (button, performUpdate) = factory(id, data)
        self.button = button
        self.performUpdate = performUpdate
    }
    
    func update(with data: WidgetData) {
        performUpdate?(data)
    }
    
    func useView(usage: (UIView) -> Void) {
        guard let button else { return }
        usage(button)
    }
}
