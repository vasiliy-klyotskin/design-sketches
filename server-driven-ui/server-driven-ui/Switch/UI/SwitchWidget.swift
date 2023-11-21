//
//  SwitchWidget.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/21/23.
//

import UIKit

final class SwitchWidget: UISwitch {
    private var onTurnOn: () -> Void = {}
    private var onTurnOff: () -> Void = {}
    
    init(onTurnOn: @escaping () -> Void, onTurnOff: @escaping () -> Void) {
        super.init(frame: .zero)
        self.onTurnOn = onTurnOn
        self.onTurnOff = onTurnOff
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc func valueChanged() {
        if isOn {
            onTurnOn()
        } else {
            onTurnOff()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: SwitchModel) {
        setOn(model.isOn, animated: true)
        isEnabled = !model.isDisabled
        UIView.animate(withDuration: 1, animations: { [weak self] in
            if model.isDisabled {
                self?.alpha = 0.5
            } else {
                self?.alpha = 1
            }
        })
    }
}
