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
    
    func loadView(for data: WidgetData, with id: WidgetId) {
        let (activity, performUpdate) = factory(id, data)
        self.activity = activity
        self.performUpdate = performUpdate
    }
    
    func update(with data: WidgetData) {
        performUpdate?(data)
    }
    
    func useView(usage: (UIView) -> Void) {
        guard let activity else { return }
        usage(activity)
    }
}
