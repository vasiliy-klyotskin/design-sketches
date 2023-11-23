//
//  StackView.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class WidgetStackView: UIStackView {
    func update(model: StackModel) {
        spacing = CGFloat(model.spacing)
        axis = .vertical
    }
    
    func insert(view: UIView, at index: Int) {
        insertArrangedSubview(view, at: index)
    }
    
    func deleteAll() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func display(views: [UIView]) {
        views.forEach(addArrangedSubview)
    }
}
