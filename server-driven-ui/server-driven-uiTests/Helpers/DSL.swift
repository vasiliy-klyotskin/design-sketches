//
//  DXL.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit
@testable import server_driven_ui

extension RootWidget {
    func findStack(for id: Int) -> WidgetStackView? {
        findViewWithTag(id, in: view) as? WidgetStackView
    }
    
    func findLabel(for id: Int) -> LabelWidget? {
        findViewWithTag(id, in: view) as? LabelWidget
    }
    
    func findView<T: UIView>(in view: UIView) -> T? {
        if let view = view as? T { return view }
        for subview in view.subviews {
            if let foundView: T = findView(in: subview) {
                return foundView
            }
        }
        return nil
    }
    
    private func findViewWithTag(_ tag: Int, in view: UIView) -> UIView? {
        if view.tag == tag {
            return view
        }
        for subview in view.subviews {
            if let foundView = findViewWithTag(tag, in: subview) {
                return foundView
            }
        }
        return nil
    }
}
