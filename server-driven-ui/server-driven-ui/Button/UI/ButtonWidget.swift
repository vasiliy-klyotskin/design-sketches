//
//  ButtonWidget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

final class ButtonWidget: UIButton {
    private var onTap: () -> Void = {}
    
    init(onTap: @escaping () -> Void) {
        super.init(frame: .zero)
        self.onTap = onTap
        addTarget(self, action: #selector(tapped), for: .touchDown)
    }
    
    @objc func tapped() {
        onTap()
    }
    
    func update(with model: ButtonModel) {
        setTitle(model.title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
