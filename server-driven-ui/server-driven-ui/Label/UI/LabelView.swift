//
//  LabelView.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/17/23.
//

import UIKit

final class LabelWidget: UILabel {
    func update(with model: LabelModel) {
        self.text = model.text
    }
}
