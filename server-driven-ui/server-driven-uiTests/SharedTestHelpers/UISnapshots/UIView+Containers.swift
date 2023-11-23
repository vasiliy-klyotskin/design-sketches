//
//  UIView+Containers.swift
//  SharedTestHelpers
//
//  Created by Василий Клецкин on 10/24/23.
//

import UIKit

public extension UIView {
    func centered(width: CGFloat? = nil, height: CGFloat? = nil) -> UIViewController {
        SnapshotContainer(view: self, width: width, height: height)
    }
}

private class SnapshotContainer: UIViewController {
    var containedView: UIView!
    var width: CGFloat?
    var height: CGFloat?
    
    convenience init(view: UIView, width: CGFloat?, height: CGFloat?) {
        self.init()
        self.width = width
        self.height = height
        self.containedView = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containedView)
        width.map {
            containedView.widthAnchor.constraint(equalToConstant: $0).isActive = true
        }
        height.map {
            containedView.heightAnchor.constraint(equalToConstant: $0).isActive = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containedView.center = .init(x: view.frame.width / 2, y: view.frame.height / 2)
    }
}
