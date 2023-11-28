//
//  ScrollView.swift
//  server-driven-ui
//
//  Created by Марина Чемезова on 23.11.2023.
//

import UIKit

final class WidgetScrollView: UIScrollView {
    init() {
        super.init(frame: .zero)
        loadContentView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: ScrollModel) {
        self.contentInset = model.contentInsets.edgeInset
        setDirection(model.direction)
    }
    
    func setContent(_ view: UIView) {
        view.fitIntoView(contentView)
    }
    
    func deleteContent() {
        contentView.removeChildren()
    }
    
    // - MARK: Private
    
    private (set) var scrollView: UIScrollView!
    private (set) var contentView: UIView!
    private (set) var heightConstraint: NSLayoutConstraint!
    private (set) var widthConstraint: NSLayoutConstraint!

    private func loadContentView() {
        contentView = UIView(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        let bottom = contentView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor)
        bottom.priority = .init(990)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            bottom
        ])
        
        widthConstraint = contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor)
        heightConstraint = contentView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor)
    }
    
    private func setDirection(_ direction: ScrollingDirection){
        switch direction {
        case .horizontal:
            widthConstraint.isActive = false
            heightConstraint.isActive = true
        case .vertical:
            widthConstraint.isActive = true
            heightConstraint.isActive = false
        default:
            widthConstraint.isActive = false
            heightConstraint.isActive = false
        }
    }


}
