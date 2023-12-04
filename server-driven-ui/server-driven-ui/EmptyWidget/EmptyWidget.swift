//
//  EmptyWidget.swift
//  server-driven-uiTests
//
//  Created by Марина Чемезова on 23.11.2023.
//

import UIKit

struct EmptyWidgetModel {
    let color: String
    let width: Float?
    let height: Float?
}

struct EmptyWidgetDTO: Decodable {
    let color: String
    let width: Float?
    let height: Float?

    var model: EmptyWidgetModel {
        .init(color: color, width: width, height: height)
    }
}

final class EmptyWidget: UIView {
    var heightConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?

    func update(with model: EmptyWidgetModel) {
        self.backgroundColor = UIColor.hexStringToUIColor(hex: model.color)
        setHeight(model.height)
        setWidth(model.width)
    }
    
    private func setHeight(_ value: Float?) {
        if let value {
            if heightConstraint == nil {
                heightConstraint = self.heightAnchor.constraint(equalToConstant: CGFloat(value))
                heightConstraint?.isActive = true
            } else {
                heightConstraint?.constant = CGFloat(value)
            }
            
        } else {
            heightConstraint?.isActive = false
            heightConstraint = nil
        }
    }
    
    private func setWidth(_ value: Float?) {
        if let value {
            if widthConstraint == nil {
                widthConstraint = self.widthAnchor.constraint(equalToConstant: CGFloat(value))
                widthConstraint?.isActive = true
            } else {
                widthConstraint?.constant = CGFloat(value)
            }
            
        } else {
            widthConstraint?.isActive = false
            widthConstraint = nil
        }
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

func emptyWidgetFactory(id: WidgetId, data: WidgetData) -> (EmptyWidget, EmptyWidgetUpdate) {
    let widget = EmptyWidget()
    let update: EmptyWidgetUpdate = { [weak widget] in
        if let dto = EmptyWidgetDTO.from($0) { widget?.update(with: dto.model) }
    }
    update(data)
    return (widget, update)
}
