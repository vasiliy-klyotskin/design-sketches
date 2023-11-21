//
//  SwitchUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias SwitchWidgetUpdate = (WidgetData) -> Void
typealias SwitchWidgetFactory = (WidgetId, WidgetData) -> (SwitchWidget, SwitchWidgetUpdate)

final class SwitchUIKitCoordinator: UIKitWidgetCoordinator {
    private var switchWidget: SwitchWidget?
    private var performUpdate: SwitchWidgetUpdate?
    private let factory: SwitchWidgetFactory
    
    init(factory: @escaping SwitchWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for data: WidgetData, with id: WidgetId) {
        let (switchWidget, performUpdate) = factory(id, data)
        self.switchWidget = switchWidget
        self.performUpdate = performUpdate
    }
    
    func update(with data: WidgetData) {
        performUpdate?(data)
    }
    
    func useView(usage: (UIView) -> Void) {
        guard let switchWidget else { return }
        usage(switchWidget)
    }
}
