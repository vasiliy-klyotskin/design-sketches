//
//  EmptyWidget.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 23.11.2023.
//

import UIKit
@testable import server_driven_ui

struct EmptyWidgetModel {
    let color: String
}

struct EmptyWidgetDTO: Decodable {
    let color: String
    
    var model: EmptyWidgetModel {
        .init(color: color)
    }
}

final class EmptyWidget: UIView {
    func update(with model: EmptyWidgetModel) {
        self.backgroundColor = UIColor.hexStringToUIColor(hex: model.color)
    }
}

typealias EmptyWidgetUpdate = (WidgetData) -> Void
typealias EmptyWidgetFactory = (WidgetId, WidgetData) -> (EmptyWidget, EmptyWidgetUpdate)

final class EmptyWidgetUIKitCoordinator: UIKitWidgetCoordinator {
    private var label: EmptyWidget?
    private var performUpdate: EmptyWidgetUpdate?
    private let factory: EmptyWidgetFactory
    
    init(factory: @escaping EmptyWidgetFactory) {
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

func emptyWidgetFactory(id: WidgetId, data: WidgetData) -> (EmptyWidget, EmptyWidgetUpdate) {
    let widget = EmptyWidget()
    let update: EmptyWidgetUpdate = { [weak widget] in
        if let dto = EmptyWidgetDTO.from($0) { widget?.update(with: dto.model) }
    }
    update(data)
    return (widget, update)
}
