//
//  RootWidget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class RootWidget: UIViewController {
    var onDidLoad: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDidLoad()
    }
    
    private var child: UIView?
    
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
