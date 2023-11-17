//
//  StackView.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class WidgetStackView: UIView {
    private lazy var stackView = {
        let stack = UIStackView()
        stack.fitIntoView(self)
        return stack
    }()
    
    func update(model: WidgetStackModel) {
        
    }
    
    func insert(view: UIView, at index: Int) {
        stackView.insertArrangedSubview(view, at: index)
    }
    
    func delete(at index: Int) {
        guard index >= 0 && index < stackView.arrangedSubviews.count else {
            return
        }

        let viewToRemove = stackView.arrangedSubviews[index]
        viewToRemove.removeFromSuperview()
    }
}
