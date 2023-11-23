//
//  StackView.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class WidgetStackView: UIStackView {
    init() {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: StackModel) {
        spacing = CGFloat(model.spacing)
        axis = .vertical
    }
    
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
