//
//  RootWidgetCoordinator.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

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
