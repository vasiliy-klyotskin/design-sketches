//
//  TopLeftBottomPresenter.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import Foundation

protocol TopLeftBottomView {
    associatedtype Child
    func set(top: Child?)
    func set(bottom: Child?)
    func set(left: Child?)
}

final class TopLeftBottomPresenter<View: TopLeftBottomView> {
    private let view: View
    
    init(view: View) {
        self.view = view
    }
    
    func present(with positioning: TopLeftBottomPositioning, children: [TopLeftBottomPositioning.ChildId: View.Child]) {
        if let top = positioning.top {
            view.set(top: children[top])
        }
        if let left = positioning.left {
            view.set(left: children[left])
        }
        if let bottom = positioning.bottom {
            view.set(bottom: children[bottom])
        }
    }
}
