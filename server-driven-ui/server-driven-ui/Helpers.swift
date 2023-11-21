//
//  Helpers.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

extension UIView {
    public func fitIntoView(_ container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.bounds
        container.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    public func removeChildren() {
        for child in subviews {
            child.removeFromSuperview()
        }
    }
}

