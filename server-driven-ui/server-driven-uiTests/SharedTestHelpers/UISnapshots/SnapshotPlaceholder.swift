//
//  SnapshotPlaceholder.swift
//  PaymentTests
//
//  Created by Василий Клецкин on 10/8/23.
//

import UIKit

public final class SnapshotPlaceholder: UIView {
    let width: CGFloat
    let height: CGFloat
    
    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width ?? .greatestFiniteMagnitude
        self.height = height ?? .greatestFiniteMagnitude
        super.init(frame: .zero)
        backgroundColor = .gray
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public  var intrinsicContentSize: CGSize {
        .init(width: width, height: height)
    }
}
