//
//  UIView+Visibility.swift
//  OrderTrackingTests
//
//  Created by Василий Клецкин on 13.02.2023.
//

import UIKit

public extension UIView {
    func isVisible(in outermostParent: UIView) -> Bool {
        func checkForVisibility(_ view: UIView) -> Bool {
            let isVisible = visibilityCriteria(of: view)
            if view == outermostParent {
                return isVisible
            }
            if let superview = view.superview {
                return isVisible && checkForVisibility(superview)
            }
            return false
        }
        
        return checkForVisibility(self)
    }
    
    private func visibilityCriteria(of view: UIView) -> Bool {
        !view.isHidden && view.alpha > 0.05
    }
}

public extension UILabel {
    func visibleText(in view: UIView) -> String? {
        visible(in: view)?.text
    }
}

public extension UIView {
    func visible(in view: UIView) -> Self? {
        if isVisible(in: view) {
            return self
        } else {
            return nil
        }
    }
}

public extension UIView {
    func findView(withID accessibilityID: String) -> UIView? {
        if accessibilityIdentifier == accessibilityID { return self }
        for subview in subviews {
            if let matchingView = subview.findView(withID: accessibilityID) {
                return matchingView
            }
        }
        return nil
    }
}
