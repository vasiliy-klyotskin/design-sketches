//
//  StackViewUIKitCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/15/23.
//

import UIKit

// Можно сделать дженерик координатор, но пока не выношу, чтобы не усложнять

typealias StackViewWidgetUpdate = (WidgetData) -> Void
typealias StackViewWidgetFactory = (WidgetId, WidgetData) -> (WidgetStackView, StackViewWidgetUpdate)

final class StackViewUIKitCoordinator: UIKitWidgetCoordinator {
    private let factory: StackViewWidgetFactory
    private var stackView: WidgetStackView?
    private var performUpdate: StackViewWidgetUpdate?
    
    init(factory: @escaping StackViewWidgetFactory) {
        self.factory = factory
    }
    
    func loadView(for data: WidgetData, with id: WidgetId) {
        let (stackView, update) = factory(id, data)
        self.stackView = stackView
        self.performUpdate = update
    }
    
    func update(with data: WidgetData) {
        performUpdate?(data)
    }
    
    func useView(usage: (UIView) -> Void) {
        guard let stackView else { return }
        usage(stackView)
    }
    
    func insertChild(view: UIView, at index: Int) {
        stackView?.insert(view: view, at: index)
    }
    
    func deleteChild(at index: Int) {
        stackView?.delete(at: index)
    }
}
