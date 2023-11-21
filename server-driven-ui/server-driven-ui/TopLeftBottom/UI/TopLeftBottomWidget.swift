//
//  TrioContainerWidget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

final class TopLeftBottomWidget: UIView, TopLeftBottomView {
    private let leftContainer = UIView()
    private let topContainer = UIView()
    private let bottomContainer = UIView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
        let hStack = UIStackView()
        let vStack = UIStackView()
        hStack.axis = .horizontal
        vStack.axis = .vertical
        hStack.addArrangedSubview(leftContainer)
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(topContainer)
        vStack.addArrangedSubview(bottomContainer)
        hStack.fitIntoView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: TopLeftBottomModel) {
        
    }
    
    func set(top view: UIView?) {
        setIfNotNilOrCleanContainer(view: view, to: topContainer)
    }
    
    func set(left view: UIView?) {
        setIfNotNilOrCleanContainer(view: view, to: leftContainer)
    }
    
    func set(bottom view: UIView?) {
        setIfNotNilOrCleanContainer(view: view, to: bottomContainer)
    }
    
    private func setIfNotNilOrCleanContainer(view: UIView?, to container: UIView) {
        if let view {
            view.fitIntoView(container)
        } else {
            container.removeChildren()
        }
    }
}
