//
//  UIViewController+Lifecycle.swift
//  ShoppingTests
//
//  Created by Марина Чемезова on 10.03.2023.
//

import UIKit

public extension UIViewController {
    func triggerLifecycleIfNeeded() {
        guard !isViewLoaded else { return }
        loadViewIfNeeded()
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func triggerViewWillAppear() {
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}

