//
//  Root.swift
//  server-driven-uiTests
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit
@testable import server_driven_ui

final class RootWidget: UIViewController {
    var child: UIView?
    
    func insert(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        let leadingConstraint = view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let topConstraint = view.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    func deleteChild() {
        child?.removeFromSuperview()
    }
}

final class RootWidgetCoordinator: UIKitWidgetCoordinator {
    let root: RootWidget
    
    init(root: RootWidget) {
        self.root = root
    }
    
    func getView(id: WidgetId) -> UIView {
        root.loadViewIfNeeded()
        return root.view
    }
    
    func update(id: WidgetId) {}
    
    func insertChild(view: UIView, at index: Int) {
        root.insert(view: view)
    }
    
    func deleteChild(at index: Int) {
        root.deleteChild()
    }
}

