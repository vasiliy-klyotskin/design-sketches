//
//  LabelView.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class LabelWidget: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.fitIntoView(self)
        return label
    }()
    
    init(model: LabelModel) {
        super.init(frame: .zero)
        label.text = model.text
    }
    
    var text: String? {
        label.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: LabelModel) {
        label.text = model.text
    }
}
