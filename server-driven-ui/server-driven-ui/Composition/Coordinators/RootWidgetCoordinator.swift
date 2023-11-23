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
    
    func getView() -> UIView? {
        root.view
    }
    
    func position(with viewModel: UIKitWidgetPositioningViewModel) {
        if let child = viewModel.children.first?.value {
            root.deleteChild()
            root.insert(view: child)
        }
    }
}
