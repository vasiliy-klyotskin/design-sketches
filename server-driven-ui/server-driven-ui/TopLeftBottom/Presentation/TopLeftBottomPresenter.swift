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
    
    func present(child: View.Child?, index: Int) {
        if index == 0 {
            view.set(top: child)
        } else if index == 1 {
            view.set(left: child)
        } else if index == 2 {
            view.set(bottom: child)
        }
    }
}
