//
//  StackView.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class WidgetStackView: UIStackView {
    func update(model: StackModel) {}
    
    func insert(view: UIView, at index: Int) {
        insertArrangedSubview(view, at: index)
    }
    
    func delete(at index: Int) {
        guard index >= 0 && index < arrangedSubviews.count else {
            return
        }

        let viewToRemove = arrangedSubviews[index]
        viewToRemove.removeFromSuperview()
    }
}
