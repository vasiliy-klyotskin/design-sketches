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
        view.backgroundColor = .white
    }
    
    private var child: UIView?
    
    func insert(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        let leadingConstraint = view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let topConstraint = view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    func deleteChild() {
        child?.removeFromSuperview()
    }
}
